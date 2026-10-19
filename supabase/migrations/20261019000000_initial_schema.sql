-- ReLeaf Initial Supabase Schema Migration
-- Migration: 20261019000000_initial_schema.sql

-- 1. Enable PostGIS Extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Areas Table
-- Stores ~3,600 satellite-derived 500m grid cells
CREATE TABLE IF NOT EXISTS public.areas (
  id TEXT PRIMARY KEY,
  name TEXT,
  geom geometry(Polygon, 4326) NOT NULL,
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  ndvi_2021 DOUBLE PRECISION,
  ndvi_2025 DOUBLE PRECISION,
  ndvi_change DOUBLE PRECISION NOT NULL,
  rain_anomaly DOUBLE PRECISION NOT NULL,
  slope DOUBLE PRECISION NOT NULL,
  priority_score DOUBLE PRECISION NOT NULL,
  tier TEXT NOT NULL CHECK (tier IN ('high', 'medium', 'low')),
  cluster_id INT NOT NULL,
  recommended_action TEXT NOT NULL,
  before_img TEXT,
  after_img TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Spatial and Filtering Indexes on Areas
CREATE INDEX IF NOT EXISTS idx_areas_geom ON public.areas USING GIST (geom);
CREATE INDEX IF NOT EXISTS idx_areas_priority_score ON public.areas (priority_score DESC);
CREATE INDEX IF NOT EXISTS idx_areas_tier ON public.areas (tier);
CREATE INDEX IF NOT EXISTS idx_areas_action ON public.areas (recommended_action);

-- 3. User Profiles Table
-- Maps directly 1:1 with auth.users
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('volunteer', 'ngo')),
  chapter TEXT NOT NULL DEFAULT 'Mulshi Chapter',
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. Restoration Drives Table
CREATE TABLE IF NOT EXISTS public.drives (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organizer_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  area_id TEXT REFERENCES public.areas(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  location_name TEXT NOT NULL,
  meeting_point TEXT NOT NULL,
  starts_at TIMESTAMPTZ NOT NULL,
  capacity INT NOT NULL CHECK (capacity > 0),
  plants_target INT NOT NULL DEFAULT 0 CHECK (plants_target >= 0),
  image_url TEXT,
  is_closed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_drives_organizer ON public.drives (organizer_id);
CREATE INDEX IF NOT EXISTS idx_drives_area ON public.drives (area_id);
CREATE INDEX IF NOT EXISTS idx_drives_starts_at ON public.drives (starts_at);
CREATE INDEX IF NOT EXISTS idx_drives_is_closed ON public.drives (is_closed);

-- 5. Drive Registrations Table
CREATE TABLE IF NOT EXISTS public.registrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drive_id UUID NOT NULL REFERENCES public.drives(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'registered' CHECK (status IN ('registered', 'checked_in')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT unique_drive_user UNIQUE (drive_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_registrations_drive ON public.registrations (drive_id);
CREATE INDEX IF NOT EXISTS idx_registrations_user ON public.registrations (user_id);

-- 6. Impact Logs Table
CREATE TABLE IF NOT EXISTS public.impact_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drive_id UUID NOT NULL REFERENCES public.drives(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  saplings INT NOT NULL DEFAULT 0 CHECK (saplings >= 0),
  hours DOUBLE PRECISION NOT NULL DEFAULT 0 CHECK (hours >= 0),
  species TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_impact_logs_user ON public.impact_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_impact_logs_drive ON public.impact_logs (drive_id);

-- 7. Notifications Table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'info',
  read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON public.notifications (user_id, read);

-- 8. Updated At Trigger Function (Secure Search Path)
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_profiles_updated ON public.profiles;
CREATE TRIGGER on_profiles_updated
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS on_drives_updated ON public.drives;
CREATE TRIGGER on_drives_updated
  BEFORE UPDATE ON public.drives
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- 9. Row Level Security (RLS) Configuration

-- 9.1 Areas RLS
ALTER TABLE public.areas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read areas" ON public.areas;
CREATE POLICY "Authenticated users can read areas"
  ON public.areas
  FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Anon users can read areas" ON public.areas;
CREATE POLICY "Anon users can read areas"
  ON public.areas
  FOR SELECT
  TO anon
  USING (true);

-- 9.2 Profiles RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read profiles" ON public.profiles;
CREATE POLICY "Authenticated users can read profiles"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- 9.3 Drives RLS
ALTER TABLE public.drives ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read drives" ON public.drives;
CREATE POLICY "Authenticated users can read drives"
  ON public.drives
  FOR SELECT
  TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Only NGOs can insert drives" ON public.drives;
CREATE POLICY "Only NGOs can insert drives"
  ON public.drives
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = organizer_id AND
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid() AND profiles.role = 'ngo'
    )
  );

DROP POLICY IF EXISTS "Organizers can update their own drives" ON public.drives;
CREATE POLICY "Organizers can update their own drives"
  ON public.drives
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = organizer_id)
  WITH CHECK (auth.uid() = organizer_id);

DROP POLICY IF EXISTS "Organizers can delete their own drives" ON public.drives;
CREATE POLICY "Organizers can delete their own drives"
  ON public.drives
  FOR DELETE
  TO authenticated
  USING (auth.uid() = organizer_id);

-- 9.4 Registrations RLS
ALTER TABLE public.registrations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users and organizers can read registrations" ON public.registrations;
CREATE POLICY "Users and organizers can read registrations"
  ON public.registrations
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM public.drives
      WHERE drives.id = registrations.drive_id AND drives.organizer_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can insert their own registration" ON public.registrations;
CREATE POLICY "Users can insert their own registration"
  ON public.registrations
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Organizers can update registrations of their drives" ON public.registrations;
CREATE POLICY "Organizers can update registrations of their drives"
  ON public.registrations
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.drives
      WHERE drives.id = registrations.drive_id AND drives.organizer_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.drives
      WHERE drives.id = registrations.drive_id AND drives.organizer_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can cancel their own registration" ON public.registrations;
CREATE POLICY "Users can cancel their own registration"
  ON public.registrations
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 9.5 Impact Logs RLS
ALTER TABLE public.impact_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can read own impact_logs"
  ON public.impact_logs
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can insert own impact_logs"
  ON public.impact_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can update own impact_logs"
  ON public.impact_logs
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can delete own impact_logs"
  ON public.impact_logs
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 9.6 Notifications RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own notifications" ON public.notifications;
CREATE POLICY "Users can read own notifications"
  ON public.notifications
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own notifications" ON public.notifications;
CREATE POLICY "Users can insert own notifications"
  ON public.notifications
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own notifications" ON public.notifications;
CREATE POLICY "Users can update own notifications"
  ON public.notifications
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own notifications" ON public.notifications;
CREATE POLICY "Users can delete own notifications"
  ON public.notifications
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- 10. RPC: join_drive
-- Safely joins a drive using row-level locking (FOR UPDATE) to prevent oversubscription
CREATE OR REPLACE FUNCTION public.join_drive(p_drive UUID)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
  v_drive RECORD;
  v_reg_count INT;
  v_already_joined BOOLEAN;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Lock drive row for update
  SELECT * INTO v_drive
  FROM public.drives
  WHERE id = p_drive
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Drive not found';
  END IF;

  IF v_drive.is_closed THEN
    RAISE EXCEPTION 'Drive is closed for registration';
  END IF;

  -- Verify user has not already registered
  SELECT EXISTS (
    SELECT 1 FROM public.registrations
    WHERE drive_id = p_drive AND user_id = v_user_id
  ) INTO v_already_joined;

  IF v_already_joined THEN
    RAISE EXCEPTION 'Already registered for this drive';
  END IF;

  -- Verify current registration count against capacity
  SELECT count(*)::INT INTO v_reg_count
  FROM public.registrations
  WHERE drive_id = p_drive;

  IF v_reg_count >= v_drive.capacity THEN
    RAISE EXCEPTION 'Drive is full (capacity reached)';
  END IF;

  -- Insert registration
  INSERT INTO public.registrations (drive_id, user_id, status)
  VALUES (p_drive, v_user_id, 'registered');

  RETURN jsonb_build_object(
    'success', true,
    'drive_id', p_drive,
    'user_id', v_user_id,
    'registered_count', v_reg_count + 1
  );
END;
$$;

REVOKE ALL ON FUNCTION public.join_drive(UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.join_drive(UUID) TO authenticated;

-- 11. View: drives_view
-- Returns drive details with registered count and linked area details
CREATE OR REPLACE VIEW public.drives_view
WITH (security_invoker = true)
AS
SELECT
  d.id,
  d.organizer_id,
  p.name AS organizer_name,
  p.chapter AS organizer_chapter,
  d.area_id,
  a.name AS area_name,
  a.priority_score AS area_priority_score,
  a.tier AS area_tier,
  a.recommended_action AS area_recommended_action,
  d.title,
  d.description,
  d.location_name,
  d.meeting_point,
  d.starts_at,
  d.capacity,
  d.plants_target,
  d.image_url,
  d.is_closed,
  d.created_at,
  d.updated_at,
  COALESCE(r.registered_count, 0)::INT AS registered_count
FROM public.drives d
LEFT JOIN public.profiles p ON p.id = d.organizer_id
LEFT JOIN public.areas a ON a.id = d.area_id
LEFT JOIN (
  SELECT drive_id, count(*)::INT AS registered_count
  FROM public.registrations
  GROUP BY drive_id
) r ON r.drive_id = d.id;

GRANT SELECT ON public.drives_view TO authenticated, anon;

-- 12. View: areas_view
-- Returns areas with GeoJSON geometry for standard API pagination
CREATE OR REPLACE VIEW public.areas_view
WITH (security_invoker = true)
AS
SELECT
  id,
  name,
  lat,
  lng,
  ST_AsGeoJSON(geom)::jsonb AS geojson,
  ndvi_2021,
  ndvi_2025,
  ndvi_change,
  rain_anomaly,
  slope,
  priority_score,
  tier,
  cluster_id,
  recommended_action,
  before_img,
  after_img
FROM public.areas;

GRANT SELECT ON public.areas_view TO authenticated, anon;

-- 13. RPC: get_areas_geojson
-- Returns full FeatureCollection in one call, bypassing the 1,000-row PostgREST limit
CREATE OR REPLACE FUNCTION public.get_areas_geojson(
  p_tier TEXT DEFAULT NULL,
  p_action TEXT DEFAULT NULL
)
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT jsonb_build_object(
    'type', 'FeatureCollection',
    'features', COALESCE(jsonb_agg(
      jsonb_build_object(
        'type', 'Feature',
        'id', a.id,
        'geometry', ST_AsGeoJSON(a.geom)::jsonb,
        'properties', jsonb_build_object(
          'id', a.id,
          'name', a.name,
          'lat', a.lat,
          'lng', a.lng,
          'ndvi_2021', a.ndvi_2021,
          'ndvi_2025', a.ndvi_2025,
          'ndvi_change', a.ndvi_change,
          'rain_anomaly', a.rain_anomaly,
          'slope', a.slope,
          'priority_score', a.priority_score,
          'tier', a.tier,
          'cluster_id', a.cluster_id,
          'recommended_action', a.recommended_action,
          'before_img', a.before_img,
          'after_img', a.after_img
        )
      )
    ), '[]'::jsonb)
  )
  FROM public.areas a
  WHERE (p_tier IS NULL OR a.tier = p_tier)
    AND (p_action IS NULL OR a.recommended_action = p_action);
$$;

REVOKE ALL ON FUNCTION public.get_areas_geojson(TEXT, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_areas_geojson(TEXT, TEXT) TO authenticated, anon;
