# Changelog

What changed in the template and when, newest first. Tags `vYYYY.MM` mark
the states that projects take files from: a project records the tag it was
generated from and lists its departures under "Project notes" in its
README. A change is made here first, tagged, and then taken up in the
projects that use it.

## Not yet tagged

- 2026-11-04. Machine fixes stay out of shared files: a TeX install that
  lacks Libertinus gets `tlmgr install libertinus-fonts` rather than a
  different font in the PDF format, and `ragg` and `systemfonts` stay in
  `DESCRIPTION` (CONVENTIONS, GUIDE sections 8 and 12).
- 2026-11-04. GUIDE section 13 rewritten: a project starts with
  `copier copy`, renv init and `quarto add`; "template first" (13.2) says
  how a general change is made, tagged and then taken up in each project
  with `copier update` and `quarto update`, and what stays a project
  matter.
- 2026-11-04. The tool-facing files are a copier template: `template/`
  holds what `copier copy gh:soffiafdz/r-analysis-template <project>`
  generates (settings, the shared helpers, the README outline, the config,
  the Quarto project files), `copier.yml` asks for the environment and
  package names, `.copier-answers.yml` records the tag, and
  `copier update` moves a project to a later tag. `README.md` and the
  config are generated once. `docs/CONVENTIONS.md` and `docs/STYLE.md`
  stay in the template, and a project's README links to them at its tag;
  the example drops its copies.
- 2026-11-04. The slide theme, fonts, logos, footer script, PDF settings
  and PowerPoint template become one Quarto extension,
  `extension/_extensions/analysis/`, installed into a project with
  `quarto add soffiafdz/r-analysis-template/extension@<tag>` and
  updated with `quarto update`. It contributes `analysis-revealjs`,
  `analysis-pdf` and `analysis-pptx`, so a document declares one format
  and `_quarto.yml` keeps only `project:` and `execute:`. The theme gains
  the vertical-stack rules and the nested-aware footer from mtl-memory-sex.
  `register_slide_font()` finds the fonts under the installed extension.
- 2026-11-04. The shared helpers (`config.R`, `logging.R`, `data_io.R`,
  `validation.R`, `tables.R`, `plotting.R`), the settings, the Quarto
  configuration and the slide theme are owned by the template and not
  edited in projects. Project functions go in their own files (`figures.R`,
  `report_tables.R`, one file per method), and project colours under
  `output.colors` in the config, which `manuscript_colors()` merges over
  its shared entries. The "project-specific" sections at the end of
  `tables.R` and `plotting.R` are gone, and the example follows.
- 2026-11-04. Data layout: `data/inputs/<source>/` holds everything a
  project takes in and never modifies, raw releases and other pipelines'
  outputs alike, one folder per source, in place of `data/raw/` and
  `data/external/`; `data/derivatives/` holds only what the project
  builds. Received file names are kept when they say source, content and
  date or version, and otherwise become
  `<cohort>_<content>[_<tool-version>]_<ISO date>` with the original name
  in the config comment. `validate_config()` requires `data: inputs:`.

## v2026.10 (2026-10-19)

The template as the October projects took it.

- 2026-10-19. Slides: four comprehension faults from a replication deck
  added to STYLE.md (one meaning per mark, the field's term, the claims
  under test shown first, choices with their origin); the style guide and
  the theme aligned with the settled rules (two caption lines, two
  statements under a full-width table, headlines of one line).
- 2026-10-16. Slides set in IBM Plex Sans, embedded from
  `reports-src/fonts/`, with every line break written by hand; a narrow
  type scale (24/30/34/48 px) with a running line; slide figures drawn at
  the size of the slide area they fill, in the slide typeface
  (`register_slide_font()`, `theme_slide()`, `output.slide_areas`); the
  example's packages declared in DESCRIPTION and its lockfile.
- 2026-10-08. Slide theme in McGill red with the Douglas and StoP-AD
  colours and logos; the PowerPoint template with the same title bar;
  `screenshot_slides.sh`; STYLE.md gains brand versus data colours, the
  card rules and the table of slide faults.
- 2026-10-07. The template as it stood, with a landing README, the MIT and
  CC BY 4.0 licences, the worked example on the penguin data with its
  rendered report and decks, the slide theme and PowerPoint template, PDF
  report defaults, table helpers for documents and slides, and fonts
  embedded in PDF figures.
