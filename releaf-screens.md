# ReLeaf — Screen Description Table

Auth: **email + OTP only**. No passwords. Sign up and log in are the same flow.
Data: all screens read from mock JSON now. Backend replaces the JSON later. No UI change.

## A. Onboarding and Auth

| # | Screen | Purpose | Key elements | Data |
|---|---|---|---|---|
| 1 | Splash / Welcome | First impression | Logo, tagline, 3 value points, Get Started, Log in | none |
| 2 | Tutorial | Teach the 3 core actions | 3 swipe cards (Map, Why this score, Join a drive), Skip, Next, dots | none |
| 3 | Email entry | Start sign up or log in | Email field, Send OTP button, terms line | auth |
| 4 | OTP verify | Confirm identity | 6-digit input, resend timer (30s), change email link, error text | auth |
| 5 | Role select | Pick user type (new users only) | Volunteer card, NGO card | profile.role |
| 6 | Profile setup | Basic details (new users only) | Name, photo, chapter/region, location permission prompt | profile |

## B. Map and Areas

| # | Screen | Purpose | Key elements | Data |
|---|---|---|---|---|
| 7 | Map (home) | See where restoration is needed | Priority / NDVI / Rainfall toggle, area markers, legend, locate-me, layers button, filter icon | areas, area_scores |
| 8 | Map filter sheet | Narrow the map | Priority level, intervention type, distance, Apply, Reset | local only |
| 9 | Area bottom sheet | Quick summary of a tapped area | Status tag, name, score, 3 key metrics, View Details | area_scores, score_factors |
| 10 | Area detail | Full explanation of one area | 2021 vs 2025 NDVI images, score card, Why this score list, recommended intervention, View Nearby Drives | areas, area_images, score_factors, area_recommendations |
| 11 | Methodology | Build trust | Data sources, how score is built, update date | static text |

## C. Drives

| # | Screen | Purpose | Key elements | Data |
|---|---|---|---|---|
| 12 | Drives list | Browse drives | Filter chips (Near me, This month, High priority), drive cards with quota bar | drives |
| 13 | Drive detail | Decide to join | Photo, NGO, date, place, linked area score, description, quota, Join button | drives, areas |
| 14 | Join confirmation | Confirm registration | Success message, Add to calendar, View my drives | registrations |
| 15 | Drive check-in / impact log | Record work done | Plants planted, hours, photo, Submit | impact_logs |

## D. Profile

| # | Screen | Purpose | Key elements | Data |
|---|---|---|---|---|
| 16 | Profile | Personal summary | Photo, name, chapter, 3 stat cards, impact card, drive history, Log out | profiles, impact_snapshots |
| 17 | Edit profile | Change details | Name, photo, chapter, Save | profiles |
| 18 | Impact detail | Show proof of results | Per-drive before/after NDVI, plants, hours | impact_snapshots |
| 19 | Notifications | Reminders and alerts | Drive reminders, new nearby drives | notifications |
| 20 | Settings | Preferences | Language, units, notification toggles, Delete account | profiles |

## E. NGO (only if NGOs use the app)

| # | Screen | Purpose | Key elements | Data |
|---|---|---|---|---|
| 21 | Create drive | Publish a drive | Title, linked area, date, place, quota, photo, Publish | drives |
| 22 | Manage drive | Run a drive | Volunteer list, mark attendance, close drive | registrations |

## F. Shared States (apply to every screen)

| State | Behaviour |
|---|---|
| Loading | Skeleton placeholders |
| Empty | Short message + one action (e.g. "No drives yet") |
| Error | Message + Retry button |
| Offline | Banner + last cached data |
| Location denied | Map opens on default pilot region |
| OTP wrong / expired | Inline error + Resend |

## G. Navigation

- Bottom bar: **Map · Drives · Profile**
- Area detail → View Nearby Drives → Drives list (filtered to that area)
- Drive detail → linked area → Area detail
- Signed-out users see only screens 1–4
