# Consul Scripts

<!-- @include: ./parts/consul-usage.md -->

## Video Demonstrations

Below are examples of these scripts in action.

::: tabs
== Attila
This video demonstrates the **Exterminare** script being used to efficiently remove two characters from the campaign map.

<video src="/ConsulScriptum/videos/attila_index.mp4" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
In this demonstration, we showcase both the **Adice Provinciam** script for transferring settlements and the **Exterminare** script to remove a character from the campaign map.

<video src="/ConsulScriptum/videos/rome2_index.mp4" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>
:::

---

## Available Scripts

<div class="compact-reference">

#### Ad Rebellos — Spawns rebellion

**ID**: `consul_adrebellos_entry`  
When activated, any settlement you click on will trigger a rebellion.

#### Adice Provinciam — Transfer settlement

**ID**: `consul_transfersettlement_entry`  
When activated, first click on the settlement you want to transfer, either from the campaign map or strategic view. Then click on the target settlement or character to which you want to transfer it.

#### Casus Belli — Force war

**ID**: `consul_force_make_war_entry`  
When activated, first click on a settlement/character to select the first faction, then click on another settlement/character to select the second faction to make war.

#### Custodes Vocati — Exchange garrison

**ID**: `consul_force_exchange_garrison_entry`  
To mobilize a garrison for field duty, first select your general's army. Then, designate the settlement with which to exchange forces. Important: Your general must be outside of a settlement for this function to work correctly.

#### Exterminare — Kill character

**ID**: `consul_exterminare_entry`  
When activated, any character you select will be exterminated.

#### Impetus — Restore action points

**ID**: `consul_replenish_action_points_entry`  
Impetus: Click on a character to grant them a surge of momentum, fully restoring their action points for the turn.

#### Incrementum — Add growth point

**ID**: `consul_incrementum_regio_entry`  
To unlock a province potential for future expansion, select this command and then click on a settlement. This represents a strategic state investment in land surveying and administrative reform, permanently granting the region +1 Growth Point. This point is required to open up new building slots, allowing for greater development.

#### Pax Aeterna — Force peace

**ID**: `consul_force_make_peace_entry`  
When activated, first click on a settlement/character to select the first faction, then click on another settlement/character to select the second faction to make peace.

#### Sedatio — Boost public order

**ID**: `consul_sedatio_provinciae_entry`  
To calm unrest and bolster loyalty, select this command and then click on a settlement. This will temporarily appease the populace, providing a significant (+10) boost to public order across the entire province. Use it to stabilize newly conquered or rebellious lands.

#### Subiugatio — Force vassalage

**ID**: `consul_force_make_vassal_entry`  
When activated, click on the character/settlement you want to subjugate, then click on the character/settlement recipient

#### Vexatio — Penalize public order

**ID**: `consul_vexatio_provinciae_entry`  
To make an example of a province or suppress dissent, select this command and then click on a settlement. This will enact a policy of official harassment, such as punitive levies or forced quartering of troops, inflicting a severe (-10) penalty to public order.

</div>

---

## Usage Notes
- **Highlighting**: When a script is active or has been triggered, the entry will highlight in green.
- **Toggle**: Click the highlighted entry again to deactivate it.

<div class="cs-ui-magnifier">
  <div class="cs-magnifier-label">Tooltip Preview</div>
  <div class="cs-magnifier-images">
    <img src="/media/consul_custodes.png" alt="Tooltip Preview 1" />
    <img src="/media/consul_custodes.png" alt="Tooltip Preview 2" />
  </div>
  <div class="cs-magnifier-hint">
    Hover your mouse over any script in the list to reveal its full usage instructions.
  </div>
</div>