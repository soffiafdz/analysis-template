# Style

The look of every report, figure, table and slide deck. GUIDE.md section 8
says how to build them; this page says what they look like.

## Colours

Colours have one of two jobs, and a colour never does both:

- **Brand colours** frame the slides: the title panel and table header
  rules. They come from the institutions whose logos are on the title page.
- **Data colours** stand for something: a group, a predictor, a measure.
  They live in `manuscript_colors()` and appear in figures.

### Brand

McGill red leads; the Douglas Research Centre and the StoP-AD Centre give
the secondary colours. For another affiliation, change the variables at the
top of `slides.scss` in the Quarto extension and the files in its `logos/`,
in the template.

| Token | Hex | Source | Used for |
|---|---|---|---|
| McGill red | `#ED1B2F` | McGill | the panel of the title and closing slides, table header rules, text selection |
| StoP-AD teal | `#1A6C7A` | centre-stopad.com | reserved for a second accent; not used on slides now |
| Douglas blue | `#177DB3` | douglas.research.mcgill.ca | links |
| Douglas navy | `#102E71` | Douglas Research Centre logo | not on slides: it is 4.9 from the `male` colour |
| Ink | `#1A1A1A` | | headlines, row labels, bold leads |
| Soft ink | `#4A4A4A` | | statements, lists, table values, subtitles |
| Muted | `#5C5C5C` | | captions, the footer, metadata |
| Rule | `#D9D9D9` | | table row lines |
| Panel | `#F5F3F2` | | note backgrounds (a grey warmed toward the red) |

Backgrounds are white. Bold text stays in ink. Red is never set as text.
Text has two tones only: ink (`#161616`) for everything that is read, grey
(`#737373`) for what only orients (captions, the running line, the event,
values that do not pass). Two greys close to each other read as one.

### Data

- Every group, predictor or measure has one named entry under
  `output.colors` in the config, which `manuscript_colors()` merges over
  its shared entries, taken from Paul Tol's colourblind-safe palettes
  (`get_palette("tol_bright")`, `"tol_muted"`). The same group has the same
  colour in every figure.
- Sex keeps `female` `#8B0000` and `male` `#191970`. Both are dark, so the
  dataviz lightness check fails them; their colourblind separation passes
  (19.2), and figures label them directly.
- A data colour is at least 15 away from every brand colour on the same
  slides, measured as the distance in OKLab times 100. Below that, a reader
  takes the frame for data. Tol's red `#EE6677` (10.9 from McGill red) and
  orange `#EE7733` (13.8) fail; so does Douglas navy against `male` (4.9).
  To check a pair:

  ```r
  ok.mat <- farver::convert_colour(
    farver::decode_colour(c("#ED1B2F", "#EE6677")), "rgb", "oklab"
  )
  100 * dist(ok.mat)
  ```

  When a project's data palette is fixed by a paper and fails against a
  brand colour, the deck adds a stylesheet of its own under the format
  (`theme: [project.scss]`, merged after the extension's) that sets that
  secondary colour to ink, and a comment there gives the pair and the
  distance.
- One mark emphasised among others is ink beside the `context` grey; that
  is emphasis, not a category.
- A colour used for text, such as a direct label on a line, needs at least
  3:1 contrast on white. Tol's bright yellow `#CCBB44` (1.9:1) is replaced
  by his dark yellow `#997700` when it labels anything.
- Lines and bands can use the full palette; colour is never the only
  encoding where a label can be added.

## Type

| Output | Font | Sizes |
|---|---|---|
| PDF (xelatex) | Libertinus Serif, Libertinus Sans headings | 10 pt body; tables via `style_pdf_table.fn()` |
| HTML slides | IBM Plex Sans, embedded from the extension's `fonts/` (SIL Open Font License), then Helvetica Neue, Arial | in slide pixels: running line 24, caption and table headers 30, body and tables 34, headline 48; title slide: title 80, subtitle 44, name 36, event 32; weights 400 and 600 |
| PowerPoint | Arial | titles 26 pt bold, body 18 pt, notes 14 pt |
| Figures | ggplot2 default sans; slide versions in IBM Plex Sans (`register_slide_font()`, drawn by ragg) | `theme_publication()` base size 10 to 12; slide versions at 30 px (`slide_text_px`), tick labels included |

The slide scale is narrow on purpose: nothing a reader needs is below 30
px, and the headline is only 1.4 times the body. Raising every size
together keeps the problem (big text too big, small text too small); the
fix is to raise the small sizes and lower the large ones.

IBM Plex Sans was chosen from rendered specimens (it replaced Source Sans
Pro, which came with Quarto by default and was never chosen): even and
crisp on a projector, with clear figures for tables of numbers. The deck
embeds its regular, italic and semibold files, so rendering needs no
network, and the figures register the same files. A weight the deck does
not embed would be synthesised by the browser and read as heavy and
blurred, so the theme stays at 400 and 600.

Every line break is written into the text, as `<br>` at a phrase
boundary. Headlines, captions, statements, table cells and the title and
closing slides do not wrap on their own (`white-space: nowrap`); a line
too long for its column runs past it, where the screenshot check catches
it, instead of breaking mid-phrase. Write a line to fit, or break it on
purpose.

## Figures

- `theme_publication()` with `use_markdown = TRUE`. Manuscript figures carry
  a bold title ending in a full stop, a subtitle with the sample, and a
  caption with the details, wrapped with `wrap_text()`.
- Lines are labelled directly where possible instead of in a legend.
- Slide versions use `theme_slide()`: no title, subtitle or caption,
  recessive grid, text in the slide inks, a legend (if any) at the
  figure's left edge. Each is drawn at the size of the area it fills on the
  slide (`output$slide_areas` in the config: full width, or the wider of
  two columns), with text at the slides' data size (`slide_text_px`), so
  it is shown at one image pixel per slide pixel and never scaled.
- The line under a figure gives the sample size, the interval type and
  what the sign of an effect means.
- Significance is shown by the marks (filled for corrected p < .05,
  hollow for not; a vertical tick for an estimate that is not a test),
  not by colour alone or only in the text.

## Tables

- gt, styled with `style_manuscript_table()`; `style_screen_table.fn()` for
  HTML, `style_pdf_table.fn()` in PDFs.
- Long row labels are shortened, not set in smaller type.
- Differences come with confidence intervals; p-values only where a test is
  informative, with the reason in the caption where they are left out.

## Captions and text

- Captions start with a bold title of 3 to 8 words ending in a full stop,
  then the details.
- No em-dashes; no stock openers ("Of note", "It is worth noting").
- Numbers in text, captions and slides come from the environment file.

## Slides

### Layout (HTML, `slides.scss` in the Quarto extension)

A 1600 by 900 pixel slide on a 12-column grid with 48 pixel gutters.

- **Title page:** one text block on white across the first 8 columns,
  centred on the slide's height: the title (80 px, semibold), the
  subtitle, then after a wider gap the name and, under it in grey, the
  event and date. The name belongs to that block; set on its own at the
  foot it looks dropped in. The last 4 columns are a McGill red panel that
  runs to the screen edges and holds the logos in white, sized to similar
  widths (McGill's reversed wordmark, the Douglas Research Centre, the
  StoP-AD Centre) and spaced evenly, so the space above and below the stack
  equals the gaps inside it. The stack is centred on the red, which runs
  past the slide edge, not on the slide.
- **Closing slide:** the same panel; on the left, a headline and the open
  questions as rows between hairlines, each a question and one grey line
  of what the data say. No name or date.
- **Content slides:** the headline, top left, states the slide's message in
  one line (about 70 characters at 48 px). Nothing sits above it.
- **Running line:** a hairline across the slide's foot, then the part of
  the talk at the left (`{data-part="Results"}` on the heading) and the
  slide number at the right, in grey tracked capitals, so it reads as the
  frame and not as content. It replaces the eyebrow over the title.
- **Body:** a figure drawn for the full width, or two columns:
  `::: {.split}` (7 + 5), `.wide-right` (5 + 7) or `.half` (6 + 6). The
  wider column holds the figure; the other holds a table at the top and a
  statement at the bottom, level with the figure's lower edge. Under a
  full-width table, two statements side by side:
  `:::: {.split .half .below}`.
- **Statements:** body size, ink, led by a semibold number or phrase. One
  or two per slide.
- **Tables:** as wide as their content, at body size; row labels left,
  numbers right in tabular figures; semibold headers over a red rule;
  light row lines. Values that do not pass (p of .05 or more) step back to
  grey (class `.ns` on the cell's text). A summary of p values across checks is
  a table, not a figure.
- **Caption:** at most two grey lines under the body, at 30 px, broken
  by hand at a phrase boundary.
- **Speaker notes** (`::: {.notes}`) take the details a listener does not
  need to read: data release, exact guideline wording, definitions.
- One message per slide. A caveat goes on the slide it qualifies, in its
  caption or as a statement, not on a list of its own.
- Not used: eyebrows over titles, big-number cards, coloured side bars on
  notes or titles, vertically centred sparse content, gaps stretched to
  fill a column, reveal's progress bar and counter.

### Faults and their fixes

Each fault below has turned up in a real deck.

| Fault | Example | Fix |
|---|---|---|
| Content crowded at the top, the lower half empty | A short table or five one-line bullets under the title | A figure drawn for the slide's free area; two columns whose text column spans the figure; caveats moved onto the slides they qualify. Centring the body only moves the gap above it, and stretching cards, rows or gaps looks artificial |
| A lot of text | A note under every table, a caption of three clauses | A caption of at most two lines; at most two statements per column; details in speaker notes |
| An ugly title page | Sizes off any scale; the name alone at the foot; logos small in a tall panel, clustered (wide bands above and below) or spread (stretched gaps) | The name in the title block; logos sized to fill the panel's width and spaced evenly |
| A type scale too wide | Title 96 and headlines 56 beside a 20 px footer and 28 px captions | Narrow the range: raise the small sizes, lower the large ones |
| Numbers inside narrow bars | Counts of 11 and 12 squeezed into stacked segments | Small multiples (one panel per group) with each count at its bar's end |
| A figure that has to be decoded | Leave-one-out p values on a reversed log axis with two thresholds | Corrected p is the only filter on a slide; influence ranges go in speaker notes as a diagnostic, never as pass or fail |
| Synthetic bold | Titles at weight 700 when only 400 and 600 are embedded | Weights the deck embeds |
| Accidental line breaks | "PREVENT-/AD" in a table header; a caption whose last word wraps; "68.3/(5.1)" | No automatic wrapping; breaks written as `<br>` at phrase boundaries; columns wide enough for their tables |
| A default typeface nobody chose | The theme's font inherited from the tool | Choose from rendered specimens; embed the files |
| An eyebrow over every title | "RESULTS · AMYLOID × FACTOR" in red caps | The part goes in the footer; the headline speaks alone |
| Big-number cards | Three grey tiles with a red top bar and a large value | The number as a direct label in the figure, or a row in a compact table |
| A heading inside a fenced div | `### Open questions` inside `::: {.title-block}` | Pandoc wraps it in a nested section, which reveal treats as a slide; use a span (`[Open questions]{.closing-head}`) |
| A line breaks inside a value or a short label | "64%" over "was 41%" | Short labels; titles that fit on one line |
| A statement that carries no information | "1,204 of 1,204" | "Every participant" or "100%"; leave out what the reader already assumes |
| Implementation detail | The list of scripts that were re-run | Name the analyses; scripts and file names belong in the README or the audit document |
| Topic titles | "Results", "Check 2" | The headline states the finding; the footer names the part |
| A loose or loaded term | "glitch" for "scored with last year's weights" | Name the thing exactly in the title, and use that term all through |
| One thing under several names or formats | "raw" and "unadjusted"; "4 of 6" and "4/6"; one decimal here, two there | One term per thing; "4/6" in tables, "4 of 6" in prose; the same decimals for the same quantity; a true minus sign (−) |
| Colour that contradicts the content | A brand colour beside a similar data colour | 15 apart between brand and data colours |
| Group order changes between slides | Controls first in a table, treated first in the figure | One order for tables, legends and facets |
| Sample sizes that are never explained | 412 on one slide, 397 on the next | A line on where each sample comes from the first time it appears; N under every figure |
| A figure that needs the speaker | No interval type, no direction of effect, significance only in the text | The line under the figure (Figures, above); filled and hollow marks |
| Thin slides | A slide holding one sentence | Merge it into the slide it qualifies |
| Invented specifics | Owners and dates in "next steps" that nobody agreed | Decisions as open questions; only facts from the data or from the people concerned |
| Unexpanded abbreviations | "NBA" for *Neurobiology of Aging* | Spell out on first use; journal names in full |
| Plain wording that reads as another quantity | "How fast tau rises with amyloid" for a slope across people, read as change over time | The field's term ("amyloid–tau slope"); plain wording only where nothing else can be read into it |
| One mark with several meanings | Filled for "corrected p < .05" on one slide, "CI excludes 0" on the next, "slope above 0" on a third | One meaning for filled marks across the deck; an estimate that is not a test gets a vertical tick (a solid dot reads as filled); findings reported elsewhere, in words only |
| The claims under test shown last | A replication whose original findings first appear on the comparison slide | An early slide with the original claims, the model behind each and what the source leaves out |
| Choices without their origin | "Pre-specified" and "main" columns with nothing saying who chose each set, when and why | One table of the definitions side by side, each headed by where it comes from and when it was fixed |

### Checking a deck

1. Render it, then screenshot every slide and look at each image for
   overflow, broken lines, misalignment, collisions and empty space:

   ```sh
   reports-src/screenshot_slides.sh outputs/reports/slides.html <dir>
   ```

2. Judge the composition, not only the overflow: the body reaches the
   lower part of the slide, the columns share their top and bottom edges,
   and every block starts at the same left edge.
3. Read the deck once as its actual reader, with the table above: what
   they already know (the field, the cohort) needs no slide, what they
   cannot know (the claims tested, each analysis choice and when it was
   made) needs one. A colleague's first read is better still.
4. After each fix, render and screenshot again.

### PowerPoint (`slides-reference.pptx` in the Quarto extension)

The same palette on Arial: a title slide with the red bar and the logos,
bold ink titles, tables, and notes in small grey text under the table or
figure.

### Logos

The extension's `logos/` holds the logos, with their sources in
`SOURCES.md`. They are trademarks of their institutions and are not covered
by the template's licence. McGill's file is its own reversed wordmark; on
the red panel the Douglas and StoP-AD logos are drawn in white by a CSS
filter, as one-colour reversed versions of the logos on the institutions'
own pages.
