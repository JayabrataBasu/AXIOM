# Axiom

# Axiom — Project Memo & Design Manifesto

## 1. Purpose

Axiom is a **private, local-first research thinking system** built for a single user. It is not a product, not a social platform, and not a productivity app in the conventional sense. It exists to externalize thinking in a way that respects how research and mathematical reasoning actually happen: non-linearly, spatially, multimodally, and over long periods of time.

The goal of Axiom is **clarity of thought**, not polish, monetization, or scale.

---

## 2. Core Philosophy

### 2.1 Local-first, durable, private

* All data lives on the user’s device
* Fully functional offline
* Backups must be possible via simple folder copy
* No accounts, no cloud dependency, no telemetry assumptions

### 2.2 Thinking is non-linear

* Ideas branch, merge, contradict, and evolve
* Spatial organization is fundamental
* Structure must be optional and late-binding

### 2.3 Capture first, refine later

* Frictionless capture is prioritized over organization
* Messy inputs are acceptable and expected
* Cleanup and formalization are optional, never forced

### 2.4 References, not embeddings

* Heavy tools (PDFs, calculators, graphs) are not embedded in the canvas
* The canvas references cognitive work done elsewhere
* Context is preserved without collapsing everything into one surface

---

## 3. Conceptual Model (Ontology)

### 3.1 The One Primary Entity: IdeaNode

Axiom has exactly one core entity: the **IdeaNode**.

An IdeaNode represents a single thought anchor.

Everything else (text, math, sketches, audio, PDFs, calculations) attaches to or references an IdeaNode.

If something cannot be expressed as an IdeaNode or attached to one, it does not belong in Axiom.

---

## 4. IdeaNode Structure

An IdeaNode:

* Has a unique identity
* Exists on a canvas at a spatial position
* Contains multiple content blocks
* Can link semantically to other IdeaNodes

### 4.1 Content Blocks

Content inside an IdeaNode is **block-based**.

Block types (initial):

* Text block (typed, multiple fonts)
* Math block (LaTeX-style, pasteable)
* Sketch block (handwriting / drawing)
* Audio block (voice notes)
* Workspace reference block
* PDF reference block

Blocks are modular, reorderable, and independently editable.

There is no monolithic editor.

---

## 5. Canvas Model

### 5.1 Role of the Canvas

The canvas is the **primary thinking surface**.

It is:

* Infinite
* Spatial
* Zoomable

It is **not**:

* A document
* A folder system
* A tool execution surface

The canvas acts as a spatial index of thought.

### 5.2 Canvas Interaction Rules

* Double-tap / double-click creates a new IdeaNode at cursor
* Writing mode is determined by input method (keyboard, stylus, mouse)
* No global mode switches
* Zoom level controls semantic detail
* Nodes can be collapsed, expanded, or minimized

### 5.3 Links and Clusters

* Links between nodes are explicit and semantic
* Proximity does not imply linkage
* Visual clusters are soft groupings, not folders

---

## 6. Workspaces (Cognitive Instruments)

### 6.1 Definition

A **Workspace** is a focused environment dedicated to one kind of thinking.

Examples:

* PDF Viewer & Annotator
* Matrix Calculator
* Graph Plotter
* Code Snippet Viewer

Workspaces are:

* Full-screen or pane-based
* Stateful
* Isolated from the canvas

### 6.2 Workspace Sessions

Each use of a workspace creates a **Workspace Session**.

A session:

* Captures inputs, outputs, and state
* Is immutable by default
* Can be explicitly forked to modify

Sessions preserve reasoning history and reproducibility.

### 6.3 Referencing Workspaces

IdeaNodes reference workspace sessions via WorkspaceRef blocks.

Clicking a reference:

* Opens the workspace
* Restores the exact session state
* Does not recompute automatically

---

## 7. PDF Handling

* PDFs are immutable and stored separately
* Annotated in a dedicated PDF workspace
* References are made via precise PDF anchors

A PDF anchor includes:

* PDF identity
* Page number
* Bounding box / passage
* Optional note

The canvas never hosts full PDFs.

---

## 8. Mathematical & Experimental Tools

* Calculators, graphers, and matrix tools exist only as workspaces
* Results are linked, not embedded
* Sessions capture exact values used at the time

This allows verification without hidden recomputation.

---

## 9. Code Handling

* Code is read-only
* Used strictly for reference
* Linked to GitHub URLs, commits, or local snapshots
* No execution, no evaluation

Code behaves like PDFs for programmers.

---

## 10. Storage Philosophy

### 10.1 One Root Directory

All Axiom data lives under a single root folder.

### 10.2 Atomic Files

* One IdeaNode per file
* One Workspace Session per file
* PDFs stored immutably

### 10.3 Human-Readable Formats

* JSON for structure
* Plain files for media
* No opaque databases

### 10.4 Failure Tolerance

* Corruption of one file must not cascade
* Canvas can be rebuilt from IdeaNodes
* PDFs and media remain untouched

---

## 11. Explicit Non-Goals

Axiom deliberately avoids:

* Cloud sync (for now)
* Collaboration
* AI features
* Social sharing
* Productivity gamification
* Complex permissions systems

These may be explored later, but they do not guide the design.

---

## 12. Guiding Principle (Summary)

> Axiom is software that respects thinking.

It prioritizes:

* Intellectual honesty
* Long-term durability
* Cognitive clarity
* Research-grade behavior

This memo serves as the **design constitution** of the project.

Any future feature or implementation decision must be defensible against this document.

