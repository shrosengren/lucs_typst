
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates


#let titlepage(
  title: none,
  subtitle: none,
  authors: (),
  course_code: none,
  date: none,
  supervisors: (),
  show_draftmode: false,
  paper: "a4"
  
) = {
set page(
  paper: paper,
  margin: (x:20mm, top:45mm, bottom:22mm),
  columns: 1
)

set align(center)


if show_draftmode {
  text(size: 14pt, fill: red)[DRAFT MODE]
}

if title != none {block()[
  #text(size: 28pt)[#title]
]}
  if subtitle != none {block(inset: 12pt)[
      #text(size: 18pt)[#subtitle]
  ]
}



v(20mm)
if authors != () {
    let count = authors.len()
  let ncols = calc.min(count, 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => [
      #text(size: 18pt)[#author.name]
    ]),
  )
}

if supervisors != () {
v(30mm)

if supervisors.len() == 1 { text(size: 11pt)[supervisor]
} else {text(size: 11pt)[supervisors]}
v(10mm)
  let count = supervisors.len()
  let ncols = calc.min(count, 3)
  grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..supervisors.map(supervisor => [
      #text(size: 14pt)[#supervisor.name]
    ]),
  )
}

if course_code != none {
  v(10mm)
  text(size: 14pt)[#course_code]
}

if date != none {
  v(10mm)
  text(size: 14pt)[#date]
}
v(1fr)
grid(
  columns: (1fr, 1fr),
  align(left)[Masteruppsats i kognitionsvetenskap \
              Avdelningen för kognitionsvetenskap \
              Filosofiska institutionen\
              Lunds universitet],
  align(right)[Master’s thesis (2 years) in Cognitive Science \
              Lund University Cognitive Science \
              Department of Philosophy \
              Lund University]
)
}


#let article(
  title: none,
  subtitle: none,
  authors: none,
  course_code: none,
  supervisors: (),
  show_titlepage: false,
  show_draftmode: false,
  date: none,
  abstract: none,
  abstract-title: none,
  keywords: (),
  cols: 2,
  margin: (x: 15mm, y: 15mm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: "Times New Roman",
  fontsize: 10pt,
  title-size: 24pt,
  subtitle-size: 18pt,
  heading-family: "Times New Roman",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: "1.1a1",
  pagenumbering: "1",
  number-depth: 2,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  
  set text(
  font: font,
)

// SETS
// HEADERS

//let number-until-with(max-level, schema) = (..numbers) => {
//  if numbers.pos().len() <= max-level {
//    numbering(schema, ..numbers)
//  }
//}

//set heading(numbering: number-until-with(number-depth, sectionnumbering))

// h1

set heading(numbering:sectionnumbering)

show heading.where(
  level: 1
): it => block(width: 100%, above: 20pt, below: 12pt)[
    #set align(left)
    #set text(14pt, weight: 700)
    #it
]
// h2
show heading.where(
  level: 2
): it => block(width: 100%, above: 18pt, below: 10pt)[
  #text(
  size: 10pt,
  weight: 400,
  style: "italic")[ 
      #it 
   ]
]
// h3
show heading.where(
  level: 3
): it =>  parbreak() + text(
  size: fontsize,
  weight: 700,
  [#context [#counter(heading).display()] ] + it.body + [.],
)

// h4
show heading.where(
  level: 4
): it => text(
  size: fontsize,
  weight: "regular",
  style: "italic",
  it.body + [.],
)

// Figures

show figure: set block(spacing: 1.2em + 3pt)

show figure.caption: it => {
  text(size:9pt)[
    #text(weight:700)[#it.supplement #context it.counter.display(it.numbering).]
  #it.body]
}

show figure.where(
  kind: table
): set figure.caption(position: top)

// Tables

show table.cell.where(y: 0): set text(weight: "bold")


// Include title page
if show_titlepage {titlepage(
  title: title,
  authors: authors,
  course_code: course_code,
  date: date,
  supervisors: supervisors,
  show_draftmode: show_draftmode,
  paper: paper
)}

/* ARTICLE */

set page(
  paper: paper,
  margin: margin,
  numbering: pagenumbering,
  columns: cols
)

set text(
  size: 10pt,
  lang: "en",
  region: "us",
  hyphenate: true,
  costs: ( hyphenation: 50%, runt: 50%, widow: 50%, orphan: 50%, )
)
set align(
  left
)
set par(
  justify: true,
  first-line-indent: 5mm,
  spacing: 0.65em,
  leading: 0.65em,  
)

//// DRAFT MODE ////
set par.line(
  numbering: n => text(red)[#n]
) if show_draftmode

set bibliography(
  title: "References",
  full: false,
  style: "american-psychological-association"
)


counter(page).update(1) // Set page counter to 1

/* Title */

place(
  top + center,
  float: true,
  scope: "parent",
  dy: 8pt,
  clearance: 20mm,
)[
  #set align(center)
  #if show_draftmode {block(text(size:10pt, fill:red)[DRAFT MODE])}
  #block(text(size: 24pt)[#title])
  #if subtitle != none [#block(text(size: 18pt)[#subtitle])]
  #v(8pt)
    #let count = authors.len()
  #let ncols = calc.min(count, 3)
  #grid(
    columns: (1fr,) * ncols,
    row-gutter: 24pt,
    ..authors.map(author => {
      block(text(size: 14pt)[#author.name])
      block(text(size: 10pt)[#author.email])
      
    }),
  )
  #block(text(size: 10pt)[#date])
]

// Abstract
emph[
  #if abstract-title != none{
    heading(numbering: none)[#text(size: 10pt, weight: "regular")[#abstract-title]]
  } 
  #abstract
  
  #if keywords != none {block(inset: (y:6pt))[
    #text(weight:700)[Keywords:] #(keywords
    .join(", ")).

    ]
  }
] 

// Table of Content
if toc {block(inset: (top: 6pt))
{
  let title = if toc_title == none {
    auto
  } else {
    toc_title
  }
  block(above: 0em, below: 2em)[
  #outline(
    title: toc_title,
    depth: toc_depth,
    indent: toc_indent
  );
  ]
}
} 

// Document
doc

}


#set table(
  inset: 6pt,
  stroke: none
)

