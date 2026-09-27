# User corrections after CAM Main v1.0

User reports: menu/native modules ready, but gameplay actions do not work. v1.0 does not match required functionality. No runtime diagnostic JSON or executor/device name supplied yet. Do not describe v1.0 as live-working.

Clarification answers:
- Auto Level must be a complete loop: select level-appropriate quest -> NPC -> accept -> objectives -> turn in if required -> repeat, change quest as level rises.
- Farm positioning: all modes selectable, ABOVE by default. Screenshots show Position Type, Look At Enemy, distance, height, Movement Type (Tween) and speed. User has not explicitly fixed numeric defaults or selected a default movement method yet.
- Targeting: separate selected mob/boss lists AND nearest-enemy mode.
- Screenshots are Ouroboros Hub/Ouwland UI references: Farming, Combat, Priority, Player; dark panels/pink accents, player info, quest progress, grouped options. They do not prove other hub's implementations.

Additional code pasted by user (not executed; repeated snippets):
1. Toolbar module (new source, exact instance path not supplied):
   - Items_Config.Equipped.Changed -> SignalEvent.ToServer("Item_Equip", Equipped.Value).
   - Toolbar One/Two/Three/Four/Five store IDs, resolved through Character_info_provider.GetItemFromId(LocalPlayer, id).
   - Toolbar input names Toolbar_1st..Toolbar_5th.
   - Restrictions Locked / ActionsDisabled, ItemRequirements.SatisfiesEquip, optional tool.check matter.
   - InputHandler.ScreenClicked -> tool.MouseDown/MouseUp and, if a server tool script exists, Tool_Mouse Down/Up with Platform_Handler.mousepos(nil, tool.MouseParams).
   - Toolbar drag -> Toolbar_Equip(destinationSlotName, sourceItemId, sourceSlotName), after restrictions and Checker.DenyLoadoutChange.
   - Never re-execute this entire UI module to repair the hub: would register extra listeners/initializers.
2. Layout loader:
   - Reads live module CAM.Client.Modules.GamePlay.Dialogue (not the same as DialogueComponent).
   - PromptTriggered with prompt Dialogue tag -> DialogueName attribute or ObjectText, passes prompt to DialogueComponent.
   - Dialogue.OpenDialogue, AttemptDialogue, CurrentDialogue.Cancel, PendingDialogue player attribute.
   - Opens local dialogue UI; not proof of server quest acceptance.
3. Dashing repeated three times: already available as new_game_analysis/sources/2_722_Dashing.lua. Skill_Controller repeated: already available as core_sources/018_Skill_Controller.lua.
   - Double Jump uses Stats.IsSkillUnlocked -> Attempt_Hold("Double Jump", "Space") -> StopHold.
   - Actual dash implementation lives in Dash_Handler.Perform, not in provided listener; no cooldown bypass established.
   - Controller has SHC, en/CK/CK2, Can_Skill/Checker, Hold/UnHold/Cancel etc. Input press alone is not proof of ability execution.

Local inspection:
- InputHandler dispatch silently returns if action has no listener; module require/table availability != registered active game listener availability. Separate executor module context is a possibility, not an established cause.
- InputHandler.ScreenClicked delegates to ListenTo("Screen").
- New toolbar source supports native equipment selection and later carefully verified consumable use. Does not establish best-gear scoring or infinite consumables.
- Missing source texts for ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue and ReplicatedStorage.Regions confirmed: paths exist in overview, not in original/core source manifests. Need their source/dependencies for complete ordinary quest acceptance and location logic. Do not ask to repeat existing 87 CORE sources.

Next diagnostic prerequisites: executor name/device, v1.0 diagnostic JSON after a failing M1 attempt, exact failure/status. Current root cause unknown. No new main or fix has been built for this latest correction.
