-- ReLeaf Security Advisor & Performance Fixes
-- Migration: 20261019000001_fix_security_advisor_warnings.sql

-- 1. Fix Critical: RLS Disabled in Public for spatial_ref_sys (created by PostGIS in public schema)
ALTER TABLE IF EXISTS public.spatial_ref_sys ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read on spatial_ref_sys" ON public.spatial_ref_sys;
CREATE POLICY "Allow public read on spatial_ref_sys"
  ON public.spatial_ref_sys
  FOR SELECT
  TO public
  USING (true);

-- 2. Fix Auth RLS Initialization Plan warnings
-- Wrapping auth.uid() in (select auth.uid()) allows Postgres to evaluate it as an InitPlan once per query
-- rather than re-evaluating it for every candidate row scanned.

-- 2.1 Profiles Policies
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = id)
  WITH CHECK ((select auth.uid()) = id);

-- 2.2 Drives Policies
DROP POLICY IF EXISTS "Only NGOs can insert drives" ON public.drives;
CREATE POLICY "Only NGOs can insert drives"
  ON public.drives
  FOR INSERT
  TO authenticated
  WITH CHECK (
    (select auth.uid()) = organizer_id AND
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = (select auth.uid()) AND profiles.role = 'ngo'
    )
  );

DROP POLICY IF EXISTS "Organizers can update their own drives" ON public.drives;
CREATE POLICY "Organizers can update their own drives"
  ON public.drives
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = organizer_id)
  WITH CHECK ((select auth.uid()) = organizer_id);

DROP POLICY IF EXISTS "Organizers can delete their own drives" ON public.drives;
CREATE POLICY "Organizers can delete their own drives"
  ON public.drives
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) = organizer_id);

-- 2.3 Registrations Policies
DROP POLICY IF EXISTS "Users and organizers can read registrations" ON public.registrations;
CREATE POLICY "Users and organizers can read registrations"
  ON public.registrations
  FOR SELECT
  TO authenticated
  USING (
    (select auth.uid()) = user_id OR
    EXISTS (
      SELECT 1 FROM public.drives
      WHERE drives.id = registrations.drive_id AND drives.organizer_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Users can insert their own registration" ON public.registrations;
CREATE POLICY "Users can insert their own registration"
  ON public.registrations
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Organizers can update registrations of their drives" ON public.registrations;
CREATE POLICY "Organizers can update registrations of their drives"
  ON public.registrations
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.drives
      WHERE drives.id = registrations.drive_id AND drives.organizer_id = (select auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.drives
      WHERE drives.id = registrations.drive_id AND drives.organizer_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Users can cancel their own registration" ON public.registrations;
CREATE POLICY "Users can cancel their own registration"
  ON public.registrations
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) = user_id);

-- 2.4 Impact Logs Policies
DROP POLICY IF EXISTS "Users can read own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can read own impact_logs"
  ON public.impact_logs
  FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can insert own impact_logs"
  ON public.impact_logs
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can update own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can update own impact_logs"
  ON public.impact_logs
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete own impact_logs" ON public.impact_logs;
CREATE POLICY "Users can delete own impact_logs"
  ON public.impact_logs
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) = user_id);

-- 2.5 Notifications Policies
DROP POLICY IF EXISTS "Users can read own notifications" ON public.notifications;
CREATE POLICY "Users can read own notifications"
  ON public.notifications
  FOR SELECT
  TO authenticated
  USING ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert own notifications" ON public.notifications;
CREATE POLICY "Users can insert own notifications"
  ON public.notifications
  FOR INSERT
  TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can update own notifications" ON public.notifications;
CREATE POLICY "Users can update own notifications"
  ON public.notifications
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete own notifications" ON public.notifications;
CREATE POLICY "Users can delete own notifications"
  ON public.notifications
  FOR DELETE
  TO authenticated
  USING ((select auth.uid()) = user_id);

