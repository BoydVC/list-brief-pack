# Peer-Review Loop Before Merge

Before declaring a burn project shipped:

## Loop
1. **Builder** finishes artifact + smoke test.
2. Spawn 2–3 **reviewer** passes (adversarial, product, security/ops).
3. Each reviewer returns: must-fix / should-fix / nit, with file paths.
4. **Graft** pass: apply must-fix; park should-fix in NEXT.md.
5. Re-run smoke. Only then mark SHIPPED.

## Reviewer prompts (short)
- Adversarial: what would embarrass us in a demo?
- Product: does the 2-minute README actually work cold?
- Ops: any irreversible action without approval? any secret leakage?

## Exit criteria
- Smoke PASS
- No open must-fix
- README + DESIGN present
