---
author:   danhorst
category: demos
filename: 2014-07-28-addressing-our-pain-points.md
layout:   demo
title:    Addressing Our Pain Points
tags:     demo, rails, design, development
---

## Notre Dame issues

* Upgrading Our Internal Applications
* Separation of Responsibilities
* Repetition of Knowledge
* Sharing Functionality from the Middle of Our Application
* Decreasing Barriers to Adoption


## Solving our own problems
- Our applications live for 3–10 years.
	- Maintenance and upgrade cycles are just as important as initial development
- Keep responsibilities separate:
	- Let Fedora describe what's there.
	- The application should present it.
- Do not repeat knowledge (DRY). Our application definitions are in at least five different places:
	- Form
	- Display
	- Model
	- Datastream
	- Search results
- How do we improve sharing?
	- We use the same low-level components
	- We can share wholesale applications like Sufia or Avalon
	- We can't effectively share things in between.
		- There isn't a clear way to separate behavior and data
	- We can't effectively share model definitions between _our own_ applications because data and behavior is deeply intertwined.

## Community issues

- Decrease barriers to adoption:
	- Keeping documentation and examples up to date
	- Bringing new developers up to speed
- Avoiding dependency purgatory

