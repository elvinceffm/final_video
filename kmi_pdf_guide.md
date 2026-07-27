# Kami HTML-to-PDF Export Guide

## Use The Native Path
- Render the HTML directly through the native Kami/WeasyPrint pipeline.
- Do not use browser screenshots as the final export path.
- Do not treat browser preview as proof that the PDF is correct.

## Structural Rules
- Keep a single authoritative slide box size.
- Match `@page` and the slide container dimensions exactly.
- Reserve footer space explicitly; do not let content rely on clipping.
- Keep the cover headline to one line unless the design intentionally supports a split title.
- Keep dense tables and label rows on one line when they are close to the width limit.

## Image Rules
- Set conservative `max-height` values for image-heavy slides.
- Reduce image height before export if a slide approaches the footer.
- Treat object-fit as a finishing aid, not as a layout safety net.
- If a slide contains a large figure and a footer, leave extra bottom clearance.

## Validation Order
1. Render the PDF from the HTML source using the native Kami/WeasyPrint path.
2. Inspect the actual PDF artifact, not just the HTML page.
3. Check the cover line count, footer clearance, and the tallest image slide first.
4. Only then compare against screenshots or browser output if needed.

## Failure Modes To Watch For
- A page-height mismatch that leaves a white strip at the bottom.
- Images or charts clipping into the footer area.
- Cover titles breaking over two lines without a deliberate design reason.
- Mis-sized figures because the slide budget was not enforced before render.

## Recommended Workflow
1. Build the HTML deck.
2. Confirm page box and slide box are identical.
3. Check the tallest slide against the footer budget.
4. Render with the native Kami path.
5. Inspect the PDF artifact.
6. If any slide clips, adjust the HTML source and rerender.

## Agent Prompt Snippet
Use this phrasing when asking an agent to export a deck:

"Render the HTML slide deck through the native Kami/WeasyPrint pipeline, keep the slide box and page box identical, reserve footer space explicitly, trim any image-heavy slides that threaten the footer, keep the cover title on one line if possible, and validate by inspecting the exported PDF artifact rather than the browser preview."