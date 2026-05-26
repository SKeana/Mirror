# Mirror

A personal calendar app. Browse your time as a week, a month, or a whole year,
block off chunks for events, and save reusable routines as "templates" you can
stamp onto any week, month, or 3-month period.

Built with Ruby on Rails 8 + SQLite + Hotwire (Turbo & Stimulus).

## Features

- **Week view** — 7-day grid (Sunday → Saturday), 24 hourly rows with faint
  gridlines, today's column tinted, and the day's date in each header.
- **Month view** — 6×7 grid; days outside the current month rendered darker;
  click any day to jump to its week.
- **Year view** — compact 4×3 grid of all 12 months on one screen; today gets
  a green outline; days that contain blocks are tinted.
- **Time blocks** — click any empty hour cell in the week view to create a
  block with title, notes, start/end time, and color. Blocks render across all
  three views (full cards in week, bars in month, tints in year).
- **Templates** — reusable routines defined relative to a period (weekly,
  monthly, or quarterly = 3 months). Apply a template to any date to stamp
  its blocks onto the matching period. The template name shows in a banner
  below the toolbar whenever you view a period it was applied to.
- **Dark mode** — toggle via the 🌓 button in the toolbar; persists across
  reloads.
- **Hamburger menu** (top-left) — quick links to Calendar, New block, and
  Templates.

## Requirements

- Ruby **3.3.x** (developed against 3.3.11)
- Bundler
- SQLite 3
- Node is **not** required — the app uses Rails' importmap, no JS build step.

## Setup

Clone, install gems, prepare the database:

```bash
git clone https://github.com/SKeana/Mirror.git
cd Mirror
bundle install
bin/rails db:prepare
```

## Running

```bash
bin/dev
```

Then open <http://localhost:3000>.

`bin/dev` runs Puma in development with code reloading enabled.

## Useful commands

```bash
bin/rails console           # Interactive REPL with the app loaded
bin/rails db:migrate        # Apply pending migrations
bin/rails db:migrate:status # See migration state
bin/rails routes            # List all routes
bin/rails test              # Run the test suite
```

## Project layout

```
app/
  controllers/
    calendar_controller.rb        # Week / month / year views
    time_blocks_controller.rb     # CRUD for individual blocks
    templates_controller.rb       # CRUD + apply for templates
    template_blocks_controller.rb # CRUD for the blocks inside a template
  models/
    time_block.rb                 # A single calendar block
    template.rb                   # A named, reusable routine
    template_block.rb             # A block inside a template (period-relative)
    template_application.rb       # Records "template X was applied to period Y"
  views/
    calendar/                     # Week, month, year templates + toolbar partial
    time_blocks/                  # New / edit form
    templates/                    # List, new, show (= editor)
    template_blocks/              # New / edit form for template blocks
  javascript/controllers/
    dark_mode_controller.js
    menu_controller.js            # Hamburger dropdown
  assets/stylesheets/
    application.css               # All styles (CSS variables drive theming)
config/routes.rb
db/migrate/                       # Schema history
```

## Data model

- **TimeBlock** — `title`, `notes`, `color`, `start_at`, `end_at`. Validated so
  `end_at > start_at`. Scope `overlapping(from, to)` for range queries.
- **Template** — `name`, `period_type` (`weekly` / `monthly` / `quarterly`).
  Knows how many days its period spans and which date anchors the period
  for any given date (weekly → Sunday, monthly → 1st, quarterly → first month
  of the quarter). `apply_to(date)` creates real `TimeBlock`s for the period
  containing `date` and records the application.
- **TemplateBlock** — belongs to a Template. Stores position **relative** to
  the period: `offset_days`, `start_minute`, `duration_minutes`, plus
  `title`, `notes`, `color`.
- **TemplateApplication** — records that a template was applied to a specific
  period (`template`, `period_type`, `period_start`). The calendar uses this
  to show the template's name in the banner whenever you view a period it
  covers. Re-applying is idempotent (`find_or_create_by`).

## Theming

Colors are CSS custom properties defined in `application.css`. Toggling dark
mode swaps a small set of variables on `<html>`:

| Variable             | Purpose                                       |
|----------------------|-----------------------------------------------|
| `--bg`, `--fg`       | Page background / foreground                  |
| `--bg-inv`, `--fg-inv` | Toolbar (always opposite the page)          |
| `--border`, `--border-faint` | Grid lines                            |
| `--today-tint`       | Tint on today's column / cell (`#157811` 15%) |
| `--other-month-tint` | Background for out-of-month cells in month view |

To re-skin the calendar, change the variable values rather than the
individual rules.
