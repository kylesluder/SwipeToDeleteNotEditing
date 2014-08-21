UITableView does not send -setEditing: when delegate implements -{willBegin,didEnd}EditingRowAtIndexPath:
===


Summary
---

I recently added an implementation of -tableView:willBeginEditingRowAtIndexPath: to my delegate, and I stopped receiving -setEditing:animated: calls that I used to receive when a swipe-to-delete session was happening.

In addition to breaking my code's expectations, this has the side effect of no longer changing the Edit bar button item into a Done button, which means that it becomes useless while a swipe-to-delete session is active.

UITableView *does* send -setEditing: when *ending* a swipe-to-delete session. And it gets worse if you implement -didEndEditingRowAtIndexPath: without implementing -willBegin -- in that case, the table view enters edit mode when swiping to delete, but fails to leave it when canceling.

Steps to Reproduce
---

1. Build and run the attached demo app.
2. Swipe to enter delete mode on any of the numbered rows.
3. Cancel swipe-to-delete.

Expected Results
---

Edit button in the nav bar turns into a Done button while swipe-to-delete is active; turns back into an Edit button when canceled. Log message indicates that -setEditing:YES was sent after -willBeginEditing, and -setEditing:NO was sent before -didEndEditing.


Actual Results
---

Edit button fails to return to Done. The delegate either gets -willBeginEditing or -setEditing:, and likewise gets either -didEndEditing and -setEditing:, but never both.


Configuration
---

iOS 8.0 beta 5 Simulator


Version & Build
---

8.0 (12A4345d)
