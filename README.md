# Analysis project template

Files and conventions for R analysis projects in which anyone with access to
the data can rebuild the software environment, run the pipeline from raw
data to report, and trace every reported number back to the code that
produced it.

A project is generated from a tagged state of the template and updated
from later tags. The shared parts (helper modules, settings, the Quarto
project files and the slide theme) stay the template's: projects take them
as they are, keep their own code in their own files, and send a needed
change to the template first. The README and the config are generated once
and then belong to the project.

## Documents

| File | Contents |
|---|---|
| [`GUIDE.md`](GUIDE.md) | The full guide, with the reasoning behind each choice; stays here |
| [`docs/CONVENTIONS.md`](docs/CONVENTIONS.md) | The short version, which projects link to at a tag |
| [`docs/STYLE.md`](docs/STYLE.md) | The look of reports, figures, tables and slides |
| [`CHANGELOG.md`](CHANGELOG.md) | What changed and when, by tag |

## Parts

[copier](https://copier.readthedocs.io) delivers the parts in
`template/` from a tag (`vYYYY.MM`):

```sh
copier copy gh:soffiafdz/analysis-template <project_dir>
copier update
```

The first starts a project; the second, run in the project, takes the
newest tag. The parts:

- the settings: `.gitignore`, `.lintr`, `.here`, `.Rprofile`,
  `environment.yml`, `DESCRIPTION`;
- the README outline and `config/pipeline_config.yaml`;
- the shared helpers in `R/utils/`;
- in `reports-src/`, the Quarto project files and `screenshot_slides.sh`,
  and the Quarto extension in `_extensions/analysis/`: the slide theme,
  the fonts, the logos, the PDF settings and the PowerPoint template, as
  the formats `analysis-revealjs`, `analysis-pdf` and `analysis-pptx`.

copier asks for the environment name and the DESCRIPTION package name,
records the tag in `.copier-answers.yml`, and merges a later tag's changes
three-way. `README.md` and `config/pipeline_config.yaml` are generated once
and then belong to the project; the rest is the template's (`GUIDE.md`
section 5). A document declares one of the three formats and nothing else.
To start a project, follow [`GUIDE.md`](GUIDE.md) section 13.1; to update
one, 13.2; to move an existing project onto the template, 13.3. A project
that also runs on a cluster follows section 3.3.

## Versions

Tags `vYYYY.MM` mark the states projects take files from, and
[`CHANGELOG.md`](CHANGELOG.md) says what each one changed. A project
records the tag it took and lists its departures in its README under
"Project notes". A change that any project could use is made here first,
tagged, and then taken up in the projects.

## Example

[`example/`](example/) is a small project started from these parts, on
the public penguin data that ship with R: three scripts, a PDF report and
two slide decks. The rendered documents are in
[`example/outputs/reports/`](example/outputs/reports/); GitHub shows the
HTML slides as source, so download `slides.html` to view them.

## Requirements

- micromamba, mamba or conda, to create the environment in
  `environment.yml` (R 4.6, Quarto 1.9, compilers and system libraries).
  R packages are installed with renv.
- TeX Live with xelatex for PDF reports; the EB Garamond and TeX Gyre
  fonts ship with it. A minimal install such as TinyTeX needs
  `tlmgr install ebgaramond tex-gyre`.
- Firefox, to screenshot slides for checking.
- Python with python-pptx, only to rebuild the PowerPoint template.
- PowerPoint, to check the PowerPoint slides; LibreOffice may lay them out
  differently.

The commands in the guide were written on macOS; `sed -i ''` is BSD sed,
and GNU sed takes `-i` alone.

## Licence

`GUIDE.md`, `CHANGELOG.md` and this README are licensed under
[CC BY 4.0](LICENSE-docs). Everything else, including the files copied into
projects, is under the [MIT licence](LICENSE), except the logos in
`template/reports-src/_extensions/analysis/logos/`, which are trademarks
of their institutions (`SOURCES.md` there), the IBM Plex Sans fonts beside
them, under the SIL Open Font License (`fonts/OFL.txt`), and the TeX Gyre
Heros fonts, under the GUST Font License (`fonts/GUST-FONT-LICENSE.txt`).
