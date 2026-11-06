---@meta
-- Hand-written types for the names the server API gives a plugin. The generator keeps these and writes the rest.

---@alias basalt.Where basalt.Position|{ world?: string, x: number, y: number, z: number }

---@alias basalt.ItemSpec string|{ id: string, count?: integer, name?: string, lore?: string[], damage?: integer, enchantments?: table<string, integer>, components?: table<string, string> }

---A task that can be cancelled.
---@class basalt.Handle
---@field cancel fun()

---@class basalt.Position
---@field world string
---@field x number
---@field y number
---@field z number
---@field chunk_x integer
---@field chunk_z integer
local Position = {}

---@param dx? number
---@param dy? number
---@param dz? number
---@return basalt.Position
function Position:offset(dx, dy, dz) end

---@param other basalt.Where
---@return number
function Position:distance(other) end

---@class basalt.Item
---@field id string
---@field count integer
---@field name? string
---@field lore string[]
---@field damage integer
---@field enchantments table<string, integer>
---@field components table<string, string> Data components by name, values as SNBT text.

---@class basalt.Inventory
---@field size integer
---@field held_slot integer
---@field held basalt.Item?
local Inventory = {}

---@param slot integer
---@return basalt.Item?
function Inventory:get(slot) end

---@param slot integer
---@param item basalt.ItemSpec?
function Inventory:set(slot, item) end

---@param item basalt.ItemSpec
---@param count? integer
---@return integer
function Inventory:add(item, count) end

---@param id string
---@param count? integer
---@return integer
function Inventory:remove(id, count) end

---@param id string
---@return integer
function Inventory:count(id) end

function Inventory:clear() end

---@class basalt.Entity
---@field id integer
---@field type string
---@field world string
---@field x number
---@field y number
---@field z number
---@field health number
---@field alive boolean
---@field uuid string
---@field yaw number
---@field pitch number
---@field on_ground boolean
---@field age integer Ticks lived.
---@field width number
---@field height number
---@field custom_name string?
---@field pos basalt.Position
---@field velocity { x: number, y: number, z: number }
---@field max_health number The max health attribute base value.
---@field absorption number Absorption hearts.
---@field fire_ticks integer Ticks left on fire.
---@field frozen_ticks integer `TicksFrozen`.
---@field air integer Air supply ticks.
---@field max_air integer 300, or 4800 for dolphins. Read only.
---@field fall_distance number
---@field no_gravity boolean
---@field invulnerable boolean Ignores damage that does not bypass invulnerability.
---@field glowing boolean
---@field silent boolean
---@field invisible boolean
---@field custom_name_visible boolean
---@field persistent boolean Never despawns.
---@field ticks_lived integer
---@field tags string[] Scoreboard tags; assigning a table replaces them all.
---@field vehicle integer Id of what it rides, -1 for none. Read only.
---@field passengers string[] Ids of the riders. Read only.
---@field no_ai boolean Goals off.
---@field can_pick_up_loot boolean
---@field target integer Id of the attack target, -1 for none.
---@field last_damage number
---@field last_damage_cause string Damage type of the last hit. Read only.
---@field last_hurt_by_player string? Uuid of the player that hurt it recently. Read only.
---@field no_damage_ticks integer Invulnerability window left.
---@field arrows_in_body integer
---@field sleeping boolean Read only.
---@field leash_holder integer Id holding the lead, -1 for none.
---@field left_handed boolean
---@field breed_age integer Negative is a baby.
---@field love_ticks integer
---@field love_cause string? Uuid that fed it.
---@field owner string? Tamed owner uuid.
---@field sitting boolean
---@field tamed_horse boolean
---@field cube_size integer Slime and magma cube size.
---@field fuse integer Primed tnt fuse.
---@field powered boolean Charged creeper.
---@field swell integer Creeper fuse progress.
---@field profession string Villager profession path.
---@field villager_level integer 1 to 5.
---@field villager_experience integer
---@field owner_id integer Id of whoever shot a projectile, -1 for none.
---@field critical boolean Critical arrow.
---@field arrow_pickup integer 0 disallowed, 1 allowed, 2 creative only.
---@field pierce_level integer
---@field explosion_power number
---@field category string Mob category such as `monster` or `creature`. Read only.
---@field display_text string? Text of a text display, MiniMessage; reaches clients that already see it.
---@field object_data integer Spawn data, such as a falling block's block state id.
---@field bolt_visual_only boolean Lightning bolt state.
---@field bolt_life integer Lightning bolt state.
---@field bolt_flashes integer Lightning bolt state.
---@field aggressive boolean The arms-up flag sent to clients; melee goals raise it while they attack.
---@field age_locked boolean An animal's age no longer moves.
---@field burns_in_day boolean Catches fire in sunlight.
---@field despawn_in_peaceful integer -1 default, 0 never, 1 despawns in peaceful.
---@field nav_open_doors boolean The default ground navigation opens doors.
---@field nav_pass_doors boolean Ground navigation may path through doors; false also stops door opening.
---@field nav_can_float boolean Ground paths may cross water at the surface instead of routing around.
---@field trading_player integer Read only: entity id of the player trading with a villager, -1 for none.
---@field fuse integer Sulfur cube: ticks left on the lit fuse, -1 when it is not primed.
---@field bounce boolean A projectile that hits a block or entity reflects its velocity instead of landing.
---@field incendiary boolean An explosive or fireball sets fires; true for fireball and small_fireball.
---@field arrow_knockback integer Arrow punch in levels; reads the weapon's punch until set.
---@field arrow_life integer Ticks an arrow has spent in the ground; it despawns at 1200.
---@field fired_from string? Item id of the weapon that fired the arrow.
---@field wither_charged boolean Blue wither skull.
---@field trident_glint boolean Enchantment glint on a thrown trident.
---@field attached_to integer Entity id a firework rocket boosts, -1 for none.
---@field eye_despawn integer Ticks an eye of ender has flown; it ends at 80.
---@field eye_drops boolean The eye drops as an item when it ends instead of shattering.
---@field bolt_cause integer Entity id that caused a lightning bolt, -1 for none.
---@field gliding boolean Forces the shared flag shown to clients.
---@field swimming boolean Forces the shared flag shown to clients.
---@field crouching boolean Forces the shared flag shown to clients.
---@field sprinting boolean Forces the shared flag shown to clients.
---@field pose integer Forces a pose by ordinal; -1 clears it.
---@field visual_fire integer -1 follows the fire, 0 never, 1 always.
---@field freeze_locked boolean Stops the freeze count from moving either way.
---@field jumping boolean Jump input flag.
---@field portal_cooldown integer Ticks until the entity may use a portal again.
---@field no_action_time integer Ticks the mob has been idle.
---@field no_physics boolean Ignores collisions and pushing.
---@field riptiding boolean Spin attack flag.
---@field bee_stingers integer Stuck stingers.
---@field bee_stinger_cooldown integer
---@field arrow_cooldown integer
---@field max_no_damage_ticks integer Length of the hurt cooldown, 20 by default.
---@field hurt_direction number Yaw offset of the last hit.
---@field visible_by_default boolean False hides the entity from everyone until shown per player.
---@field spawn_reason string Read only: why the mob spawned.
---@field sound_volume number Read only: voice volume of the mob.
---@field move_forward number Movement input of the mob controller.
---@field move_sideways number Movement input of the mob controller.
---@field move_up number Movement input of the mob controller.
---@field active_slot integer Read only: hand of the item in use, 0 main, 1 off, -1 none.
---@field active_ticks integer Remaining ticks of an item use.
---@field active_used integer Elapsed ticks of an item use.
---@field creeper_ignited boolean Creeper swells and blows up.
---@field creeper_igniter integer Entity id of who lit the creeper, -1 none.
---@field evoker_wololo integer Entity id of the sheep the evoker turns red, -1 none.
---@field polar_standing boolean Polar bear on its hind legs.
---@field strider_shivering boolean The cold look of a strider.
---@field turtle_laying_egg boolean
---@field turtle_going_home boolean
---@field parrot_dancing boolean
---@field wither_portals boolean Wither allowed through portals.
---@field cube_wander boolean False: a slime, magma cube or sulfur cube never hops by itself.
---@field boost_total integer Item steering boost length of a pig or strider.
---@field boost_time integer Ticks of the boost gone.
---@field boost_active boolean Read only: a boost is running.
---@field witch_drinking boolean Read only.
---@field witch_use_ticks integer Ticks left on the witch's drink.
---@field bat_target string? `"x,y,z"` the flight goal heads for.
---@field guardian_moving boolean Read only: spikes drawn in while it moves.
---@field cart_detonate number Write only: speed squared a tnt minecart blows up with on its next turn.
local Entity = {}

function Entity:remove() end

---@overload fun(self: basalt.Entity, x: number, y: number, z: number): boolean
---@param where basalt.Where
---@return boolean
function Entity:teleport(where) end

---Hurts through the combat path (invulnerability window, armour, events); `cause` is a damage type path, default `generic`.
---@param amount number
---@param cause? string
---@param attacker_id? integer
---@return boolean
function Entity:damage(amount, cause, attacker_id) end

---Dies now, running the death sequence.
---@return boolean
function Entity:kill() end

---Gives a status effect; -1 ticks is infinite.
---@param effect string
---@param ticks integer
---@param amplifier integer
---@param ambient? boolean
---@param particles? boolean
---@param icon? boolean
---@return boolean
function Entity:add_effect(effect, ticks, amplifier, ambient, particles, icon) end

---@param effect string
---@return boolean
function Entity:remove_effect(effect) end

---@return boolean
function Entity:clear_effects() end

---@param effect string
---@return boolean
function Entity:has_effect(effect) end

---@return { effect: string, duration: string, amplifier: string, ambient: string, particles: string, icon: string }[]
function Entity:effects() end

---The attribute value with modifiers.
---@param id string
---@return number
function Entity:attribute(id) end

---@param id string
---@return number
function Entity:attribute_base(id) end

---@param id string
---@return number
function Entity:attribute_default(id) end

---@param id string
---@param value number
---@return boolean
function Entity:set_attribute_base(id, value) end

---@param id string
---@return boolean
function Entity:has_attribute(id) end

---@param id string
---@return { id: string, amount: number, operation: string }[]
function Entity:attribute_modifiers(id) end

---@param attribute string
---@param id string
---@param amount number
---@param operation "add_value"|"add_multiplied_base"|"add_multiplied_total"
---@return boolean
function Entity:add_attribute_modifier(attribute, id, amount, operation) end

---@param attribute string
---@param id string
---@return boolean
function Entity:remove_attribute_modifier(attribute, id) end

---The stack in a slot as NBT bytes.
---@param slot "mainhand"|"offhand"|"feet"|"legs"|"chest"|"head"|"body"|"saddle"
---@return string?
function Entity:equipment(slot) end

---A nil stack clears the slot.
---@param slot "mainhand"|"offhand"|"feet"|"legs"|"chest"|"head"|"body"|"saddle"
---@param stack_nbt string?
---@return boolean
function Entity:set_equipment(slot, stack_nbt) end

---@param slot string
---@return number
function Entity:drop_chance(slot) end

---@param slot string
---@param chance number
---@return boolean
function Entity:set_drop_chance(slot, chance) end

---@param vehicle_id integer
---@return boolean
function Entity:mount(vehicle_id) end

---@return boolean
function Entity:dismount() end

---Throws all riders off.
---@return boolean
function Entity:eject() end

---Vanilla knockback away from (x, z).
---@param strength number
---@param x number
---@param z number
---@return boolean
function Entity:knockback(strength, x, z) end

---Adds to the velocity.
---@param x number
---@param y number
---@param z number
---@return boolean
function Entity:push(x, y, z) end

---Turns the head towards a point.
---@param x number
---@param y number
---@param z number
---@param yaw_speed? number
---@param pitch_speed? number
---@return boolean
function Entity:look_at(x, y, z, yaw_speed, pitch_speed) end

---Starts walking a path to the point; `speed` is a modifier, default 1.0.
---@param x number
---@param y number
---@param z number
---@param speed? number
---@return boolean
function Entity:move_to(x, y, z, speed) end

---@param x number
---@param y number
---@param z number
---@return boolean
function Entity:can_reach(x, y, z) end

---@return boolean
function Entity:stop_path() end

---@return boolean
function Entity:has_path() end

---The block nodes the native pathfinder would walk to a point, as flat x, y, z triples; empty when it cannot reach; nothing starts moving.
---@overload fun(self: basalt.Entity, x: number, y: number, z: number): string[]
---@param x number
---@param y number
---@param z number
---@return string[] nodes
function Entity:find_path(x, y, z) end

---The nodes of the path the mob is walking, as flat x, y, z triples; empty without one.
---@return string[] nodes
function Entity:path_nodes() end

---Adds a goal a plugin owns next to the vanilla ones; `flags` is a comma list of `move look jump target`.
---@param key string
---@param priority integer
---@param flags? string
---@return boolean
function Entity:add_goal(key, priority, flags) end

---Retires every goal with that key, vanilla ones by name such as `panic`; returns how many.
---@param key string
---@return integer
function Entity:remove_goal(key) end

---Retires every goal that locks one of the flags, or all of them when none is given.
---@param flags? string
---@return integer
function Entity:remove_goals(flags) end

---@param key string
---@return boolean
function Entity:has_goal(key) end

---The selector as it stands.
---@return { key: string, priority: integer, running: boolean, plugin: boolean, usable: boolean, flags: string }[]
function Entity:goals() end

---Brain memory value: a boolean, number or string; `{ "entity", id }`, `{ "position", dimension, x, y, z }`, `{ "walk", x, y, z, entity, speed, close }` or `{ "list", "b|1", "entity|12", ... }`.
---@alias BrainValue boolean|number|string|string[]

---Gives the mob a brain (or reuses it) and registers memory keys such as `walk_target` or `home`.
---@param ... string|string[]
---@return boolean
function Entity:brain_register(...) end

---True when the mob has a brain.
---@return boolean
function Entity:brain_has() end

---Drops the brain.
---@return boolean
function Entity:brain_clear() end

---The memory value, or nil when empty or unregistered.
---@param key string
---@return BrainValue?
function Entity:brain_memory(key) end

---Sets a registered memory, forever or for `ticks`; false when the key is not registered.
---@param key string
---@param value BrainValue
---@param ticks? integer
---@return boolean
function Entity:brain_set_memory(key, value, ticks) end

---@param key string
---@return boolean
function Entity:brain_erase_memory(key) end

---Empties every memory.
---@return boolean
function Entity:brain_clear_memories() end

---@param key string
---@return boolean
function Entity:brain_has_memory(key) end

---`status` is `present`, `absent` or `registered`.
---@param key string
---@param status string
---@return boolean
function Entity:brain_check_memory(key, status) end

---Ticks left before the memory expires: -1 when it never does, nil when empty.
---@param key string
---@return integer?
function Entity:brain_memory_ttl(key) end

---Every registered memory.
---@return { key: string, present: string, ttl: string }[]
function Entity:brain_memories() end

---Defines an activity; requirements are `key=present|absent|registered`, and the memories listed are erased when it stops.
---@param name string
---@param requirements? string[]
---@param erase_when_stopped? string[]
---@return boolean
function Entity:brain_define_activity(name, requirements, erase_when_stopped) end

---Names a behavior row of an activity (lower priority runs first); a plugin answers it in the `entity.behavior` event, phases `can_use`, `start`, `can_continue`, `tick` and `stop`, with at most 24 calls per mob per tick.
---@param activity string
---@param priority integer
---@param key string
---@return boolean
function Entity:brain_add_behavior(activity, priority, key) end

---@return boolean
function Entity:brain_clear_behaviors() end

---@return { activity: string, priority: string, key: string }[]
function Entity:brain_behaviors() end

---Activities that are always active next to the chosen one (`core` by default).
---@param ... string|string[]
---@return boolean
function Entity:brain_set_core(...) end

---@param name string
---@return boolean
function Entity:brain_set_default(name) end

---`mode` is `if_possible` (default: falls back to the default activity), `force` or `default`.
---@param name string
---@param mode? string
---@return boolean
function Entity:brain_set_activity(name, mode) end

---Picks the first activity whose requirements hold.
---@param ... string|string[]
---@return boolean
function Entity:brain_first_valid(...) end

---Active activities, core ones included.
---@return string[]
function Entity:brain_active() end

---@return string?
function Entity:brain_active_non_core() end

---@param name string
---@return boolean
function Entity:brain_is_active(name) end

---`villager` follows the day schedule of villagers; empty clears it.
---@param name string
---@return boolean
function Entity:brain_schedule(name) end

---Sensors that fill memories: `nearest_living_entities` (`mobs`, `visible_mobs`) and `nearest_players`, as `name` or `name@range`.
---@param ... string|string[]
---@return boolean
function Entity:brain_sensors(...) end

---Expires memories and moves the schedule once for this game tick; the server does it every tick anyway.
---@return boolean
function Entity:brain_tick() end

---Sulfur cube: holds an explosive item, is alive and its fuse is not lit.
---@return boolean
function Entity:sulfur_can_explode() end

---Sulfur cube: lights the fuse (a short random one when imminent); false when it cannot explode or `tnt_explodes` is off.
---@param imminent boolean
---@return boolean
function Entity:sulfur_prime(imminent) end

---The projectile hits that entity on its next tick, through the code of a real hit.
---@param id integer
---@return boolean
function Entity:hit_entity(id) end

---A thrown potion splashes or a wind charge bursts where it is, on the next tick.
---@return boolean
function Entity:land() end

---Registers a hook spawned by a plugin as that player's own bobber.
---@param player_id integer
---@return boolean
function Entity:hook_own(player_id) end

---The hook's owner reels in with the rod in that hand; the rod wear, -1 when there is nothing to reel.
---@param off_hand boolean
---@return integer
function Entity:hook_retrieve(off_hand) end

---The x, y, z an eye of ender flies towards, empty when none.
---@return string[]
function Entity:eye_target() end

---@param x number
---@param y number
---@param z number
---@param reset boolean Restarts the flight timer.
---@return boolean
function Entity:set_eye_target(x, y, z, reset) end

---Runs an operation by name, such as `is_breed_item`.
---@param operation string
---@param ... any
---@return any
function Entity:call(operation, ...) end

---Any property by name, including `loot_table` (string) and `loot_seed` (integer).
---@param name string
---@return any
function Entity:get(name) end

---@param name string
---@param value any
---@return boolean
function Entity:set(name, value) end

---The whole entity NBT, or the compound at a dotted path.
---@param path? string
---@return string?
function Entity:nbt(path) end

---@param path string
---@return any
function Entity:nbt_value(path) end

---`uuid` takes a uuid string and saves it as four ints; `pos` takes `"x,y,z"` and saves three ints. Remove a key with `e:call("nbt_remove", path)`.
---@param path string
---@param type "bool"|"byte"|"short"|"int"|"long"|"float"|"double"|"string"|"uuid"|"pos"
---@param value any
---@return boolean
function Entity:nbt_set(path, type, value) end

---Merges a compound into the entity; live fields are updated, the rest is kept as extra data.
---@param nbt string
---@return boolean
function Entity:merge_nbt(nbt) end

---@class basalt.Player
---@field name string
---@field uuid string
---@field online boolean
---@field health number
---@field food integer
---@field gamemode string
---@field level integer
---@field world string
---@field x number
---@field y number
---@field z number
---@field ping integer
---@field sneaking boolean
---@field held_item? string
---@field attributes table<string, number>
---@field inventory basalt.Inventory
---@field pos basalt.Position
---@field data table<string, any>
---@field allow_flight boolean May fly; resets to the game mode's rule when the game mode changes.
---@field flying boolean Is flying; true only when `allow_flight`.
---@field fly_speed number Default 0.1, range -1 to 1.
---@field walk_speed number Default 0.2, range -1 to 1; also writes the `movement_speed` attribute.
---@field sprinting boolean
---@field swimming boolean
---@field gliding boolean
---@field exhaustion number
---@field saturation number
---@field exp number Progress to the next level, 0 to 1.
---@field total_experience integer Setting it resets the player to level 0 and gives that many points.
---@field exp_to_next_level integer Read only: the points the current level needs.
---@field health_scale number? Scales the health bar the client draws to this many points; nil is off.
---@field sleeping_ignored boolean
---@field collidable boolean
---@field affects_spawning boolean
---@field flying_fall_damage boolean
---@field exp_cooldown integer
---@field attack_cooldown number Read only: attack strength, 0 to 1.
---@field tab_header string? This player's tab list header; while it or the footer is set the configured tab list stays off for them.
---@field tab_footer string? This player's tab list footer.
---@field list_name string? The name everybody sees in the tab list; nil is the plain name.
---@field listed boolean Everybody sees them in the tab list.
---@field list_order integer Tab list sort order.
---@field player_time integer? Read only: the time override, nil when none.
---@field player_time_relative boolean Read only: the override moves with the world clock.
---@field player_weather string? Read only: `"clear"` or `"downfall"` override, nil when none.
---@field spectator_target integer Entity id the spectator camera follows, -1 for none.
---@field compass_target number[]? Read only: `{x, y, z}` set by `set_compass_target`.
---@field locale string Read only: client option.
---@field client_brand string Read only.
---@field client_view_distance integer Read only.
---@field client_particles integer Read only.
---@field main_hand integer Read only: 0 left, 1 right.
---@field skin_parts integer Read only.
---@field chat_visibility integer Read only.
---@field protocol_version integer Read only.
---@field pack_status integer Read only: the last resource pack answer, -1 for none.
---@field chat_colors boolean Read only.
---@field text_filtering boolean Read only.
---@field server_listings boolean Read only.
---@field virtual_host string Read only: the host the client connected to.
---@field enchantment_seed integer
---@field score integer The death screen score.
---@field previous_gamemode string? Read only: the game mode before the last change.
---@field sleep_ticks integer Read only: ticks asleep.
---@field fishing_hook integer Read only: entity id of the bobber, -1 for none.
---@field seen_win_screen boolean Not saved.
---@field view_distance integer? Per-player distance in chunks; nil restores the server's.
---@field simulation_distance integer? Per-player distance in chunks; nil restores the server's.
---@field pose integer Read only: the protocol pose id.
---@field use_ticks integer Read only: ticks the active item has been used, -1 for none.
---@field use_remaining integer Ticks left on the active item, -1 for none.
---@field visual_fire integer -1 follows the fire, 0 never, 1 always.
---@field fixed_pose integer Pose id, -1 for none.
---@field no_physics boolean Spectators always.
---@field freeze_locked boolean Only round-trips for now.
---@field waypoint_style string
---@field waypoint_color integer RGB, -1 for none.
---@field body_yaw number
---@field hurt_direction number
---@field no_action_ticks integer
---@field maximum_air integer
---@field max_no_damage_ticks integer The hurt cooldown.
---@field shield_delay integer Ticks a raised shield waits.
---@field saturated_regen_ticks integer
---@field unsaturated_regen_ticks integer
---@field starvation_ticks integer
---@field killer string? Uuid of the player credited with the last hit.
---@field slot_limit integer The most one inventory slot holds, 1 to 99.
local Player = {}

---@param message string
---@param vars? table<string, any>
function Player:send(message, vars) end

---@param message string
---@param vars? table<string, any>
function Player:action_bar(message, vars) end

---@param text string
---@param subtitle? string
---@param timing? { fade_in?: integer, stay?: integer, fade_out?: integer }
function Player:title(text, subtitle, timing) end

---@overload fun(self: basalt.Player, name: string, value: number): boolean
---@param name string
---@return number?
function Player:attribute(name) end

---@param name string
---@param volume? number
---@param pitch? number
function Player:sound(name, volume, pitch) end

---@overload fun(self: basalt.Player, name: string, at: basalt.Where, count?: integer, speed?: number)
---@param name string
---@param count? integer
---@param speed? number
function Player:particle(name, count, speed) end

---@param name string
---@param seconds? number
---@param level? integer
---@return boolean
function Player:effect(name, seconds, level) end

---@param message string
---@param vars? table<string, any>
function Player:kick(message, vars) end

---@param permission string
---@return boolean
function Player:may(permission) end

---@param id string
---@param count? integer
---@return boolean
function Player:give(id, count) end

---@overload fun(self: basalt.Player, world: string, x: number, y: number, z: number): boolean
---@overload fun(self: basalt.Player, x: number, y: number, z: number): boolean
---@param where basalt.Where
---@return boolean
function Player:teleport(where) end

---Grants a permission on top of the player's group, for the session; the source is this plugin.
---@param node string
function Player:grant(node) end

---Denies a permission on top of the player's group, for the session.
---@param node string
function Player:deny(node) end

---Drops this plugin's grant or denial of a permission.
---@param node string
function Player:revoke(node) end

---Adds experience points.
---@param points number
---@return true
function Player:give_exp(points) end

---Adds levels.
---@param n integer
---@return true
function Player:give_levels(n) end

---Resends the real health to the client.
---@return true
function Player:send_health() end

---Resends the real experience to the client.
---@return true
function Player:send_experience() end

---Shows the client other values without changing the player.
---@param health number
---@param food integer
---@param saturation number
---@return boolean
function Player:fake_health(health, food, saturation) end

---Shows the client other values without changing the player.
---@param progress number
---@param level integer
---@return boolean
function Player:fake_experience(progress, level) end

---Restarts the attack ticker.
---@return true
function Player:reset_attack_cooldown() end

---@param kind "title"|"subtitle"|"actionbar"
---@param text string
---@return boolean
function Player:title_part(kind, text) end

---Title timing in ticks.
---@param fade_in integer
---@param stay integer
---@param fade_out integer
---@return boolean
function Player:title_times(fade_in, stay, fade_out) end

---@param reset? boolean
---@return boolean
function Player:clear_title(reset) end

---Sets both at once; nil clears.
---@param header string?
---@param footer string?
---@return true
function Player:tab_list(header, footer) end

---Categories: master, music, record, weather, block, hostile, neutral, player, ambient, voice, ui.
---@param sound string
---@param category string
---@param x number
---@param y number
---@param z number
---@param volume number
---@param pitch number
---@param seed integer
---@return true
function Player:sound_at(sound, category, x, y, z, volume, pitch, seed) end

---A sound at an entity's position.
---@param sound string
---@param category string
---@param entity_id integer
---@param volume number
---@param pitch number
---@param seed integer
---@return true
function Player:sound_entity(sound, category, entity_id, volume, pitch, seed) end

---Stops matching sounds; with both nil stops all.
---@param sound? string
---@param category? string
---@return boolean
function Player:stop_sound(sound, category) end

---The trailing data depends on the particle: block state id, color, dust, spell, number, delay, item id or trail.
---@param name string
---@param x number
---@param y number
---@param z number
---@param count integer
---@param ox number
---@param oy number
---@param oz number
---@param sx number
---@param sy number
---@param sz number
---@param force boolean
---@param randomization number
---@param ... number
---@return boolean
function Player:particle_at(name, x, y, z, count, ox, oy, oz, sx, sy, sz, force, randomization, ...) end

---A level event.
---@param id integer
---@param x number
---@param y number
---@param z number
---@param data integer
---@return boolean
function Player:world_event(id, x, y, z, data) end

---An entity event (status byte) for this player.
---@param entity_id integer
---@param event integer
---@return boolean
function Player:entity_event(entity_id, event) end

---Resends the command tree.
---@return true
function Player:update_commands() end

---This player's own clock; absolute freezes it.
---@param time integer
---@param relative? boolean
---@return true
function Player:set_player_time(time, relative) end

---@return true
function Player:reset_player_time() end

---nil resets.
---@param kind? "downfall"|"clear"
---@return true
function Player:set_player_weather(kind) end

---Hides an entity or player from this viewer.
---@param id integer
---@return boolean
function Player:hide_entity(id) end

---@param id integer
---@return boolean
function Player:show_entity(id) end

---Whether the entity is visible to this viewer.
---@param id integer
---@return boolean
function Player:can_see(id) end

---Reads or sets whether an entity is visible to viewers that did not ask.
---@param id integer
---@param visible? boolean
---@return boolean
function Player:visible_by_default(id, visible) end

---This viewer's tab list entry for another player.
---@param entity_id integer
---@param listed boolean
---@return boolean
function Player:list_player(entity_id, listed) end

---@param entity_id integer
---@return boolean
function Player:list_unlisted(entity_id) end

---@param x number
---@param y number
---@param z number
---@return boolean
function Player:set_compass_target(x, y, z) end

---Shows one block differently.
---@param x integer
---@param y integer
---@param z integer
---@param state_id integer
---@return boolean
function Player:block_change(x, y, z, state_id) end

---Cracking stage 0 to 9; -1 clears.
---@param x integer
---@param y integer
---@param z integer
---@param stage integer
---@param entity_id? integer
---@return boolean
function Player:block_damage(x, y, z, stage, entity_id) end

---Shows sign text; lines are joined by newline, MiniMessage.
---@param x integer
---@param y integer
---@param z integer
---@param front string
---@param back string
---@param color? string
---@param glowing? boolean
---@param type? string
---@return boolean
function Player:sign_text(x, y, z, front, back, color, glowing, type) end

---Opens the sign editor.
---@param x integer
---@param y integer
---@param z integer
---@param front? boolean
---@return boolean
function Player:open_sign(x, y, z, front) end

---Ticks left.
---@param item string
---@return integer
function Player:cooldown(item) end

---Starts or clears an item cooldown.
---@param item string
---@param ticks integer
---@return true
function Player:set_cooldown(item, ticks) end

---By stored key, such as `minecraft:custom/minecraft:jump`.
---@param key string
---@return integer
function Player:statistic(key) end

---@param key string
---@param n integer
---@return true
function Player:set_statistic(key, n) end

---@param key string
---@param n? integer
---@return true
function Player:inc_statistic(key, n) end

---Moves the client to another server.
---@param host string
---@param port integer
---@return boolean
function Player:transfer(host, port) end

---@param uuid string
---@param url string
---@param hash string
---@param required? boolean
---@param prompt? string
---@return boolean
function Player:resource_pack(uuid, url, hash, required, prompt) end

---nil removes all.
---@param uuid? string
---@return boolean
function Player:remove_resource_pack(uuid) end

---A raw game event packet (win game 4, demo 5, elder guardian 10...).
---@param event integer
---@param param number
---@return boolean
function Player:game_event(event, param) end

---This player's own world border.
---@param cx number
---@param cz number
---@param size number
---@param warn_blocks? integer
---@param warn_seconds? integer
---@return boolean
function Player:border_set(cx, cz, size, warn_blocks, warn_seconds) end

---@return boolean
function Player:border_reset() end

---@return boolean
function Player:wake_up() end

---Reaches everyone in the world.
---@param offhand? boolean
---@return boolean
function Player:swing(offhand) end

---Reaches everyone in the world.
---@param yaw number
---@return boolean
function Player:hurt_animation(yaw) end

---Shows an entity's equipment slot differently; slot 0 is the main hand, 7 the saddle, empty snbt clears.
---@param entity_id integer
---@param slot integer
---@param snbt string
---@return boolean
function Player:send_equipment(entity_id, slot, snbt) end

---Turns the client's view toward a point.
---@param x number
---@param y number
---@param z number
---@param eyes? boolean
---@return boolean
function Player:look_at(x, y, z, eyes) end

---0 adds, 1 removes, 2 sets.
---@param action 0|1|2
---@param list string[]
---@return boolean
function Player:chat_completions(action, list) end

---@return string[]
function Player:known_recipes() end

---@param list string[]
---@return integer
function Player:discover_recipes(list) end

---@param list string[]
---@return integer
function Player:undiscover_recipes(list) end

---@param id string
---@return boolean
function Player:has_recipe(id) end

---The stored respawn point `{world, x, y, z, yaw}`.
---@return table?
function Player:spawn_point() end

---@param world string
---@param x number
---@param y number
---@param z number
---@param yaw number
---@return boolean
function Player:set_spawn_point(world, x, y, z, yaw) end

---@return boolean
function Player:clear_spawn_point() end

---The recovery compass target.
---@return table?
function Player:last_death() end

---@param dimension string
---@param x integer
---@param y integer
---@param z integer
---@return boolean
function Player:set_last_death(dimension, x, y, z) end

---Starts using the item of a hand (eat, draw a bow, raise a shield, spyglass).
---@param offhand boolean
---@return boolean
function Player:use_start(offhand) end

---Finishes the active item now.
---@return boolean
function Player:use_complete() end

---Drops the active item without finishing it.
---@return boolean
function Player:use_clear() end

---The entity on a shoulder as its saved compound, or an empty string.
---@param side integer 0 left, 1 right.
---@return string
function Player:shoulder(side) end

---@param side integer 0 left, 1 right.
---@param snbt string
function Player:set_shoulder(side, snbt) end

---@param ticks integer
---@param damage number
---@param item_snbt string
function Player:riptide(ticks, damage, item_snbt) end

---@param riptiding boolean
function Player:set_riptiding(riptiding) end

---Attaches a rocket to a gliding player; the entity id, or -1.
---@param item_snbt string
---@return integer
function Player:firework_boost(item_snbt) end

---Sleeps in the bed at the position; `force` skips range, obstruction and time checks.
---@param x integer
---@param y integer
---@param z integer
---@param force boolean
---@return boolean
function Player:sleep(x, y, z, force) end

---Sends the block entity data of a block to this player only.
---@param x integer
---@param y integer
---@param z integer
---@param block_id string
---@param snbt string
function Player:block_entity(x, y, z, block_id, snbt) end

---Reloads the stored record into the live player and resyncs the client.
function Player:load_data() end

---The damage log, 8 values per entry: damage type, message id, direct entity id, cause entity id, damage, fall distance, fall location, game tick.
---@return any[]
function Player:combat() end

function Player:combat_clear() end

---@param type string
---@param message_id string
---@param direct integer
---@param cause integer
---@param damage number
---@param fall_distance number
---@param location string
---@param tick integer
function Player:combat_push(type, message_id, direct, cause, damage, fall_distance, location, tick) end

---Sends the recipe packet and the recipe book again.
function Player:resend_recipes() end

---A merchant window with trades a plugin made, `offers_snbt` being `{offers:[{buy, buy2, sell, uses, max_uses, xp, price_multiplier, demand, special_price}]}`.
---@param title_json string
---@param offers_snbt string
---@return boolean
function Player:open_merchant(title_json, offers_snbt) end

---Opens a villager's trades.
---@param entity_id integer
---@return boolean
function Player:open_trades(entity_id) end

---Replaces the profile properties (the skin) and refreshes the tab list entry and every viewer.
---@param name string
---@param value string
---@param signature? string
function Player:set_profile(name, value, signature, ...) end

---A custom report details packet as key, value pairs, at most 32 pairs.
---@param key string
---@param value string
function Player:report_details(key, value, ...) end

function Player:clear_dialog() end

---Removes a signed chat message from the client.
---@param signature_hex string The 256 byte signature as hex.
function Player:delete_chat(signature_hex) end

---Shows a dialog: SNBT starting with `{` or the id of a registry dialog; answers arrive as `player.custom_click`.
---@param dialog string
---@return boolean
function Player:show_dialog(dialog) end

---Sends the client back to the configuration phase and into the world again; false for a client without one.
---@return boolean
function Player:reenter_configuration() end

---The player saved as an entity compound in SNBT.
---@return string
function Player:as_string() end

---Reopens the open screen under a new title.
---@param json string
---@return boolean
function Player:window_title(json) end

---One ender chest slot as an item compound.
---@param i integer
---@return string
function Player:ender_slot(i) end

---@param i integer
---@param snbt string
---@return boolean
function Player:set_ender_slot(i, snbt) end

---Shader post effects shown to the player.
---@return string[]
function Player:post_effects() end

---@param list string[]
---@return boolean
function Player:set_post_effects(list) end

---Respawns a dead player.
---@return boolean
function Player:respawn() end

---Says something in chat as the player.
---@param text string
---@return boolean
function Player:chat(text) end

---Saves the player record.
---@return boolean
function Player:save_data() end

---Who ran a command: the console or a player.
---@class basalt.Source
---@field name string
---@field is_console boolean
local Source = {}

---@param message string
---@param vars? table<string, any>
function Source:send(message, vars) end

---@class basalt.NPC
---@field id integer
---@field uuid string
---@field name string
---@field world string
---@field x number
---@field y number
---@field z number
---@field alive boolean
local NPC = {}

function NPC:remove() end

---@class basalt.Hologram
---@field id integer
---@field type string
---@field world string
---@field x number
---@field y number
---@field z number
---@field alive boolean
---@field text string
local Hologram = {}

function Hologram:remove() end

---@class basalt.World
---@field name string
---@field time integer
---@field raining boolean
---@field thundering boolean
---@field difficulty string
---@field rules table<string, any>
---@field dimension string
---@field seed integer
---@field min_height integer
---@field height integer
---@field day_time integer
---@field block_version integer Moves when a block changes or a chunk loads or unloads.
---@field folder string The world folder on disk, under worlds/.
---@field player_count integer Players in the world.
---@field block_entity_count integer Loaded block entities.
---@field border table Snapshot `{center_x, center_z, size, target_size, lerp_ticks, damage_amount, damage_buffer, warning_distance, warning_time}`.
---@field view_distance integer Applies as players join or change world.
---@field sea_level integer Read only.
---@field forced_chunks { [integer]: { [1]: integer, [2]: integer } } Read only: `{{x, z}}`.
---@field weather_times { rain: integer, thunder: integer, clear: integer } Read only: ticks left.
---@field spawn_rules { limits?: table<string, integer>, ticks_per?: table<string, integer>, allow_monsters?: boolean, allow_animals?: boolean } Only the categories a plugin changed.
---@field tickable_block_entity_count integer Loaded block entities that run code every tick.
local World = {}

---The biome id at a block, such as `minecraft:plains`.
---@param x integer
---@param y integer
---@param z integer
---@return string?
function World:biome(x, y, z) end

---@param x integer
---@param y integer
---@param z integer
---@param biome string
---@return boolean
function World:set_biome(x, y, z, biome) end

---The highest y whose block counts for the kind, or one below the world when there is none.
---@param x integer
---@param z integer
---@param kind? "surface"|"ocean_floor"|"motion_blocking"
---@return integer
function World:highest(x, z, kind) end

---@param chunk_x integer
---@param chunk_z integer
---@return boolean
function World:chunk_loaded(chunk_x, chunk_z) end

---Loads or generates the chunk, and returns whether it is there afterwards.
---@param chunk_x integer
---@param chunk_z integer
---@param generate? boolean
---@return boolean
function World:load_chunk(chunk_x, chunk_z, generate) end

---Saves and drops a chunk nobody is using; false when a player still sees it.
---@param chunk_x integer
---@param chunk_z integer
---@return boolean
function World:unload_chunk(chunk_x, chunk_z) end

---The time of day, 0 to 23999.
---@param ticks integer
function World:set_time(ticks) end

---@param raining boolean
---@param thundering? boolean
function World:set_weather(raining, thundering) end

---@param x integer
---@param y integer
---@param z integer
function World:set_spawn(x, y, z) end

---@overload fun(self: basalt.World, x: integer, y: integer, z: integer): string
---@param where basalt.Where
---@return string
function World:block(where) end

---@overload fun(self: basalt.World, x: integer, y: integer, z: integer): table
---@param where basalt.Where
---@return table
function World:block_state(where) end

---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, block: string): boolean
---@param where basalt.Where
---@param block string
---@return boolean
function World:set_block(where, block) end

---@overload fun(self: basalt.World, name: string, value: any): boolean
---@param name string
---@return any
function World:rule(name) end

---@overload fun(self: basalt.World, type: string, x: number, y: number, z: number): basalt.Entity?
---@param type string
---@param where basalt.Where
---@return basalt.Entity?
function World:spawn(type, where) end

---Spawns with a facing and the spawn event reason (default `plugin`).
---@param type string
---@param x number
---@param y number
---@param z number
---@param yaw? number
---@param reason? string
---@return basalt.Entity?
function World:spawn_as(type, x, y, z, yaw, reason) end

---Puts an item on the ground; `item` is as in `inventory:set`.
---@param item basalt.ItemSpec
---@param x number
---@param y number
---@param z number
---@param vx? number
---@param vy? number
---@param vz? number
---@return basalt.Entity?
function World:drop_item(item, x, y, z, vx, vy, vz) end

---An explosion of the given power; blocks are spared when `break_blocks` is false (default true).
---@param x number
---@param y number
---@param z number
---@param power number
---@param break_blocks? boolean
---@param source_id? integer
---@param fire? boolean Sets fires, false by default.
---@return boolean
function World:explode(x, y, z, power, break_blocks, source_id, fire) end

---The sculk shrieker at the block tries to shriek for that player.
---@param x integer
---@param y integer
---@param z integer
---@param player_uuid string
---@return boolean
function World:sculk_shriek(x, y, z, player_uuid) end

---The sculk catalyst at the block blooms and starts a sculk charge at the source block.
---@param x integer
---@param y integer
---@param z integer
---@param source_x integer
---@param source_y integer
---@param source_z integer
---@param charge integer
---@return boolean
function World:sculk_bloom(x, y, z, source_x, source_y, source_z, charge) end

---Ticks the cursors of the sculk catalyst at the block once; false when there is nothing to spread.
---@param x integer
---@param y integer
---@param z integer
---@return boolean
function World:sculk_update(x, y, z) end

---`"spawn"` gives the heart a creaking and answers its uuid; `"resin"` spreads a clump and answers its `"x,y,z"`.
---@param action "spawn"|"resin"
---@param x integer
---@param y integer
---@param z integer
---@return string?
function World:creaking_heart(action, x, y, z) end

---The plugin-owned compound of the world as SNBT.
---@return string
function World:plugin_data() end

---@param snbt string
function World:set_plugin_data(snbt) end

---@param chunk_x integer
---@param chunk_z integer
---@return string
function World:chunk_data(chunk_x, chunk_z) end

---@param chunk_x integer
---@param chunk_z integer
---@param snbt string
function World:set_chunk_data(chunk_x, chunk_z, snbt) end

---@param pos basalt.Where
---@return string
function World:block_entity_data(pos) end

---@param pos basalt.Where
---@param snbt string
function World:set_block_entity_data(pos, snbt) end

---@param entity basalt.Entity|integer
---@return string
function World:entity_data(entity) end

---@param entity basalt.Entity|integer
---@param snbt string
function World:set_entity_data(entity, snbt) end

---@overload fun(self: basalt.World, text: string, x: number, y: number, z: number): basalt.Hologram?
---@param text string
---@param where basalt.Where
---@return basalt.Hologram?
function World:hologram(text, where) end

---@param options table
---@return basalt.NPC?
function World:npc(options) end

---Block state ids of a section, 4096 of them, index = y * 256 + z * 16 + x, from 1.
---@param chunk_x integer
---@param section_y integer
---@param chunk_z integer
---@param load? boolean Load or generate the chunk when it is not there (default true).
---@return integer[]? states Nil when the chunk is not loaded and load is false.
function World:section(chunk_x, section_y, chunk_z, load) end

---Writes a whole section; a negative id keeps the block. Returns false when the chunk or section is out of range.
---@param chunk_x integer
---@param section_y integer
---@param chunk_z integer
---@param states integer[] 4096 state ids.
---@param notify? boolean Show the change to the players who see it (default true).
---@return boolean
function World:set_section(chunk_x, section_y, chunk_z, states, notify) end

---Writes several sections of one chunk; returns the blocks changed, and with `previous` the old states.
---@param chunk_x integer
---@param chunk_z integer
---@param sections table<integer, integer[]> section_y to 4096 state ids; a negative id keeps the block.
---@param options? { resend?: boolean, previous?: boolean }
---@return integer? changed
---@return table<integer, integer[]>? previous
function World:apply_chunk(chunk_x, chunk_z, sections, options) end

---Writes many chunks in one go. Few changes reach the players as block changes, many as the chunk again.
---@param chunks { x: integer, z: integer, sections: table<integer, integer[]> }[]
---@param options? { resend?: boolean, previous?: boolean }
---@return integer? changed Nil when something was out of range (everything else is still applied).
---@return table<integer, table<integer, integer[]>>? previous Per chunk, section_y to the old states.
function World:apply_chunks(chunks, options) end

---Every section of a chunk at once, keyed by section y, each a list of 4096 state ids as in `World:section`.
---@param chunk_x integer
---@param chunk_z integer
---@param load? boolean Load or generate the chunk when it is not there (default true).
---@return table<integer, integer[]>? sections Nil when the chunk is not loaded and load is false.
function World:chunk_sections(chunk_x, chunk_z, load) end

---Where a chunk stands: `unloaded`, `queued` (asked for and on its way), `loaded` or `ticking` (loaded near a player).
---@param chunk_x integer
---@param chunk_z integer
---@return "unloaded"|"queued"|"loaded"|"ticking"
function World:chunk_status(chunk_x, chunk_z) end

---Keeps chunks loaded for a holder until `release_chunks` is called with the same token.
---@param token string
---@param chunks integer[][] Pairs of { chunk_x, chunk_z }.
---@return boolean
function World:hold_chunks(token, chunks) end

---Lets go of everything a token held.
---@param token string
function World:release_chunks(token) end

---Runs the effects of a block change on blocks already written; `effects` is a list of names or their bits added up.
---@param positions integer[][] { x, y, z } triples.
---@param effects? string[]|integer
---@param previous? integer[] One state id per position, or nothing for unknown.
---@return integer reached How many positions were in a loaded chunk.
function World:update_neighbors(positions, effects, previous) end

---Tells the block at each position that a neighbor changed (`neighborChanged`); `sources` is the state that told it.
---@param positions integer[][] { x, y, z } triples.
---@param sources? integer[] One state id per position, or nothing for unknown.
---@return integer reached
function World:neighbor_changed(positions, sources) end

---Lets the blocks around each position reshape to fit it (`updateNeighbourShapes`); `states` runs the indirect variant.
---@param positions integer[][] { x, y, z } triples.
---@param states? integer[] One state id per position.
---@return integer reached
function World:update_shapes(positions, states) end

---What a block state would settle to at a position against its neighbours; nothing is written.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, state: integer): integer
---@param where basalt.Where
---@param state integer
---@return integer state
function World:valid_state(where, state) end

---Books a tick of the block at a position, `delay` ticks away, or of the fluid in it when `kind` is `"fluid"`.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, delay: integer, kind?: "block"|"fluid"): boolean
---@param where basalt.Where
---@param delay integer
---@param kind? "block"|"fluid"
---@return boolean booked False when there is nothing to tick there.
function World:schedule_tick(where, delay, kind) end

---Uses an item on a face of the block at a position as a player would; only block items so far, returns blocks placed.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, face: string, item: string, yaw?: number, pitch?: number): integer
---@param where basalt.Where
---@param face "down"|"up"|"north"|"south"|"west"|"east"
---@param item string
---@param yaw? number
---@param pitch? number
---@return integer placed
function World:use_item_on(where, face, item, yaw, pitch) end

---Writes states at positions, then runs `effects` for the blocks that changed, as `Level.setBlock` would.
---@param positions integer[][] { x, y, z } triples.
---@param states integer[] One state id per position.
---@param effects? string[]|integer
---@return integer changed
function World:apply_changes(positions, states, effects) end

---The state ids at positions, -1 where the chunk is not loaded and `load` is false.
---@param positions integer[][] { x, y, z } triples.
---@param load? boolean Load or generate the chunks (default true).
---@return integer[]
function World:read_states(positions, load) end

---Writes states at positions. Returns how many blocks changed.
---@param positions integer[][] { x, y, z } triples.
---@param states integer[] One state id per position.
---@param notify? boolean Show the change to the players who see it (default true).
---@return integer changed
function World:write_states(positions, states, notify) end

---Sends the chunks again to every player near them.
---@param chunks integer[][] Pairs of { chunk_x, chunk_z }.
function World:resend_chunks(chunks) end

---Works the light of the chunks out again off the tick thread, then shows them again to the players near them.
---@param chunks integer[][] Pairs of { chunk_x, chunk_z }.
function World:relight_chunks(chunks) end

---The light level at a position, 0 to 15, brought up to date first; nil when the chunk is not loaded.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, layer: "block"|"sky"): integer?
---@param where basalt.Where
---@param layer "block"|"sky"
---@return integer?
function World:light_at(where, layer) end

---The light of a section as 2048 bytes, two levels each, low nibble first; nil when not loaded or lit.
---@param chunk_x integer
---@param section_y integer
---@param chunk_z integer
---@param layer "block"|"sky"
---@param load? boolean Load or generate the chunk (default true).
---@param fresh? boolean Work the light out first when blocks around changed (default true).
---@return string?
function World:light_section(chunk_x, section_y, chunk_z, layer, load, fresh) end

---Replaces the light of a section with 2048 bytes in the layout `light_section` gives.
---@param chunk_x integer
---@param section_y integer
---@param chunk_z integer
---@param layer "block"|"sky"
---@param bytes string
---@return boolean
function World:set_light_section(chunk_x, section_y, chunk_z, layer, bytes) end

---Queues the light around blocks to be worked out again, as when a block there changed.
---@param positions integer[][] { x, y, z } triples.
function World:check_light(positions) end

---The chunks that are loaded, as { chunk_x, chunk_z } pairs.
---@return integer[][]
function World:loaded_chunks() end

---A block entity (chest, sign, banner...) as SNBT with id, x, y and z included; nil when the position holds none.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer): string?
---@param where basalt.Where
---@return string?
function World:block_entity(where) end

---Replaces the data of the block entity at a position with SNBT; false when the block owns none.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, snbt: string): boolean
---@param where basalt.Where
---@param snbt string
---@return boolean
function World:set_block_entity(where, snbt) end

---Gives the block at a position a block entity from SNBT or its defaults; false when the block owns none.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, snbt?: string): boolean
---@param where basalt.Where
---@param snbt? string
---@return boolean
function World:create_block_entity(where, snbt) end

---Takes the block entity at a position away and leaves the block. False when there was none.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer): boolean
---@param where basalt.Where
---@return boolean
function World:remove_block_entity(where) end

---Where the block entities of a loaded chunk are.
---@param chunk_x integer
---@param chunk_z integer
---@return integer[][] positions { x, y, z } triples in world coordinates.
function World:block_entities(chunk_x, chunk_z) end

---An entity as the SNBT the world would save it as (id, Pos, Rotation, Motion, UUID...).
---@param entity basalt.Entity|integer An entity or its id.
---@return string?
function World:entity_nbt(entity) end

---Brings an entity back from the SNBT `entity_nbt` gave; `entity.spawn` is asked with `cause` (default `plugin`).
---@param snbt string
---@param cause? string
---@return basalt.Entity?
function World:spawn_nbt(snbt, cause) end

---Takes the entity with this uuid out of the world.
---@param uuid string
---@return boolean removed False when no live entity has that uuid.
function World:remove_entity(uuid) end

---An entity of this world by id or uuid.
---@param id integer|string
---@return basalt.Entity?
function World:entity(id) end

---The entities of a chunk, which are the ones it will save.
---@param chunk_x integer
---@param chunk_z integer
---@return basalt.Entity[]
function World:entities_in(chunk_x, chunk_z) end

---The biome names of a chunk's 4 by 4 by 4 cells, index (cell_y * 4 + cell_z) * 4 + cell_x from 1; nil when not loaded.
---@param chunk_x integer
---@param chunk_z integer
---@return string[]?
function World:biomes(chunk_x, chunk_z) end

---Writes biomes in the same order and shows the chunk again; a cell that is not a string keeps its biome.
---@param chunk_x integer
---@param chunk_z integer
---@param biomes (string|false)[]
---@return boolean
function World:set_biomes(chunk_x, chunk_z, biomes) end

---@return basalt.Entity[]
function World:entities(...) end

---Any of the `border` fields plus `seconds` for a moving size.
---@param settings table
function World:set_border(settings) end

---Plays a sound to the players in range (16 blocks scaled by the volume). Categories: master, music, records, weather, blocks, hostile, neutral, players, ambient, voice.
---@param sound string
---@param x number
---@param y number
---@param z number
---@param volume? number
---@param pitch? number
---@param category? string
---@param seed? integer
function World:sound(sound, x, y, z, volume, pitch, category, seed) end

---`{type, x, y, z, count, offset_x, offset_y, offset_z, speed | speed_x/y/z, randomization, force, data = {numbers}, item, player = uuid}`; `data` feeds the particle's own options in order.
---@param spec table
function World:particle(spec) end

---A level event by number; non-global reaches players within 64 blocks.
---@param type integer
---@param x number
---@param y number
---@param z number
---@param data? integer
---@param global? boolean
function World:level_event(type, x, y, z, data, global) end

---What the block would drop; nothing is spawned.
---@param x integer
---@param y integer
---@param z integer
---@param tool_item? string
---@param enchantments? table<string, integer>
---@return { item: string, count: integer, components: any }[]?
function World:drops(x, y, z, tool_item, enchantments) end

---Breaks the block like a player, with drops and neighbour updates.
---@param x integer
---@param y integer
---@param z integer
---@param tool_item? string
---@param enchantments? table<string, integer>
---@param drops? boolean
---@return boolean
function World:break_block(x, y, z, tool_item, enchantments, drops) end

---False when nothing there grows.
---@param x integer
---@param y integer
---@param z integer
---@return boolean
function World:bone_meal(x, y, z) end

---The redstone signal, 0 to 15, the block gives toward the face.
---@param x integer
---@param y integer
---@param z integer
---@param face integer|string
---@param direct? boolean
---@return integer
function World:signal(x, y, z, face, direct) end

---Whether the state would stand at the position.
---@param x integer
---@param y integer
---@param z integer
---@param state integer
---@return boolean
function World:survives(x, y, z, state) end

---Sends a block event (chest lid, bell, note) to the players within 64 blocks.
---@param x integer
---@param y integer
---@param z integer
---@param first integer
---@param second integer
function World:block_event(x, y, z, first, second) end

---@param cx integer
---@param cz integer
---@param forced? boolean
function World:force_chunk(cx, cz, forced) end

---@param times { rain?: integer, thunder?: integer, clear?: integer }
function World:set_weather_times(times) end

---Ticks players stood in the loaded chunk.
---@param cx integer
---@param cz integer
---@param set? integer
---@return integer
function World:inhabited_time(cx, cz, set) end

---`bounds` is `{minx, miny, minz, maxx, maxy, maxz}`.
---@param cx integer
---@param cz integer
---@return { structure: string, chunk_x: integer, chunk_z: integer, bounds: integer[], pieces: table[] }[]
function World:structures(cx, cz) end

---Whether the world's difficulty is locked.
---@type boolean
World.difficulty_locked = false

---Sets the difficulty (`"peaceful"`, `"easy"`, `"normal"` or `"hard"`); false when locked or unknown.
---@param difficulty string
---@return boolean
function World:set_difficulty(difficulty) end

---Locks or unlocks the difficulty.
---@param locked? boolean
function World:set_difficulty_locked(locked) end

---Each raid is `{id, started, ticks_active, omen_level, status, groups_spawned, total_groups, total_health, center, heroes, raiders, leaders}`, `leaders` mapping a wave to its leader's entity id.
---@return table[]
function World:raids() end

---Acts on a raid: `"stop"`, `"join"` (`entity`, `wave`), `"set_leader"` (`wave`, `entity`), `"remove_leader"` (`wave`) or `"create"` (`player`, `x`, `y`, `z`, `amplifier`, with no raid id). Answers the raid id, or nil.
---@param id? integer
---@param action "stop"|"join"|"set_leader"|"remove_leader"|"create"
---@param fields? { entity?: integer, wave?: integer, player?: integer, x?: integer, y?: integer, z?: integer, amplifier?: integer }
---@return integer? id
function World:raid_control(id, action, fields) end

---The world's clock: total ticks, rate, whether it is paused and the time markers (name to tick of the day).
---@return { ticks: integer, rate: number, paused: boolean, markers: table<string, integer> }
function World:clock() end

---Sets the clock rate (0.00001 to 1000) and tells the clients; false when out of range.
---@param rate number
---@return boolean
function World:set_clock_rate(rate) end

---Moves the clock to the next time of a time marker such as `"noon"`.
---@param marker string
---@return "none"|"not_moved"|"moved"
function World:move_to_time_marker(marker) end

---@param id integer
---@param fields { omen_level?: integer, total_groups?: integer }
---@return boolean
function World:set_raid(id, fields) end

---@param x integer
---@param y integer
---@param z integer
---@return { fluid: "empty"|"water"|"lava", source: boolean, level: integer, falling: boolean }
function World:fluid(x, y, z) end

---The multi-noise climate parameters at a block position, or nil when the world has no multi-noise biome source.
---@param x integer
---@param y integer
---@param z integer
---@return { temperature: number, humidity: number, continentalness: number, erosion: number, depth: number, weirdness: number }|nil
function World:climate(x, y, z) end

---The pyramid levels under a beacon and the colour (rgb) and height of each beam section above it, bottom up.
---@param x integer
---@param y integer
---@param z integer
---@return { levels: integer, sections: { color: integer, height: integer }[] }
function World:beacon_scan(x, y, z) end

---Where a strike near the column lands, a rod first.
---@param x integer
---@param z integer
---@return { x: integer, y: integer, z: integer }?
function World:lightning_target(x, z) end

---Raises a game event that sculk sensors hear.
---@param event string
---@param x number
---@param y number
---@param z number
---@param source_uuid? string
function World:game_event(event, x, y, z, source_uuid) end

---Grows the tree of a sapling block put at the position.
---@param x integer
---@param y integer
---@param z integer
---@param sapling_block string
---@return boolean
function World:grow_tree(x, y, z, sapling_block) end

---@param x integer
---@param y integer
---@param z integer
---@param radius integer
---@param types? string[]
---@param occupancy? "free"|"taken"|"any"
---@return { type: string, x: integer, y: integer, z: integer, free_tickets: integer }[]
function World:pois(x, y, z, radius, types, occupancy) end

---A negative value restores vanilla. Categories: monster, creature, ambient, axolotls, underground_water_creature, water_creature, water_ambient, misc.
---@param rules { limits?: table<string, integer>, ticks_per?: table<string, integer>, allow_monsters?: boolean, allow_animals?: boolean }
function World:set_spawn_rules(rules) end

---The flow vector of the fluid at a block, zero when none.
---@param x integer
---@param y integer
---@param z integer
---@return { x: number, y: number, z: number }
function World:fluid_flow(x, y, z) end

---One random tick on that block; true when a block changed.
---@param x integer
---@param y integer
---@param z integer
---@return boolean
function World:random_tick(x, y, z) end

---Plants a named tree feature as the world generator would; with `apply` false nothing changes and the blocks it would set come back. Nil when it does not fit.
---@param tree "oak"|"fancy_oak"|"swamp_oak"|"azalea"|"birch"|"super_birch"|"jungle_tree"|"jungle_bush"|"mega_jungle"|"spruce"|"pine"|"acacia"|"dark_oak"|"pale_oak"|"pale_oak_creaking"|"mega_spruce"|"mega_pine"|"mangrove"|"tall_mangrove"|"cherry"
---@param x integer
---@param y integer
---@param z integer
---@param apply? boolean
---@return { x: integer, y: integer, z: integer, before: string, after: string }[]?
function World:place_tree(tree, x, y, z, apply) end

---`void_damage` (0 or 1), `void_damage_amount`, `void_damage_offset`, `simulation_distance`, `hardcore` (0 or 1), `loot_refill` (0 or 1) or `loot_reloot_seconds` (-1 for never).
---@param key string
---@return number?
function World:tunable(key) end

---@param key string
---@param value number
---@return boolean
function World:set_tunable(key, value) end

---@class basalt.Menu
---@field title string
---@field rows integer
---@field size integer
local Menu = {}

---@param slot integer
---@param item basalt.ItemSpec
---@param onClick? fun(click: { player: basalt.Player, slot: integer })
function Menu:set(slot, item, onClick) end

function Menu:clear() end

---@param player basalt.Player
function Menu:open(player) end

---@param player basalt.Player
function Menu:close(player) end

---One line of a form.
---@class basalt.FormField
---@field key string
---@field type? "text"|"toggle"|"slider"|"choice"
---@field label? string
---@field initial? string|boolean|number
---@field min? number
---@field max? number
---@field step? number
---@field options? string[]

---@class basalt.FormAnswer
---@field player basalt.Player
---@field button integer
---@field values table<string, string|boolean|number>

---@class basalt.Form
---@field title string
local Form = {}

---@param player basalt.Player
---@param onAnswer fun(answer: basalt.FormAnswer)
function Form:open(player, onAnswer) end

---@param player basalt.Player
function Form:close(player) end

---@class basalt.Surface
---@field priority integer
---@field when? fun(player: basalt.Player): boolean
---@field title? string|fun(player: basalt.Player): string
---@field lines? string[]|fun(player: basalt.Player): string

---Waits that many ticks, from inside a handler that can wait.
---@param ticks? integer
function wait(ticks) end

---Waits until the server runs the code that owns that place.
---@overload fun(world: string, x: number, z: number)
---@param where basalt.Where
function at(where) end

---Waits until a chunk is loaded, generating it in the background unless `generate` is false; `urgent` jumps the queue.
---@param world string
---@param chunk_x integer
---@param chunk_z integer
---@param options? { generate?: boolean, urgent?: boolean }
function request_chunk(world, chunk_x, chunk_z, options) end

---@param ticks integer
---@param fn fun()
---@return basalt.Handle
function later(ticks, fn) end

---@overload fun(delay: integer, period: integer, fn: fun()): basalt.Handle
---@param period integer
---@param fn fun()
---@return basalt.Handle
function every(period, fn) end

---@param message string
---@param vars? table<string, any>
function broadcast(message, vars) end

---@param key string
---@param vars? table<string, any>
---@return string
function t(key, vars) end

---@param text string
---@param player? basalt.Player
---@return string
function fill(text, player) end

---@param name string
---@param fn fun(player: basalt.Player?): string
function placeholder(name, fn) end

---@param world string
---@param x number
---@param y number
---@param z number
---@return basalt.Position
function pos(world, x, y, z) end

---@param spec string
---@param fn fun(source: basalt.Source, ...: any)
---@param options? { permission?: string }
function cmd(spec, fn, options) end

---@param options { title?: string, rows?: integer }
---@return basalt.Menu
function menu(options) end

---@param options { title?: string, body?: string|string[], fields?: basalt.FormField[], buttons?: string[] }
---@return basalt.Form
function form(options) end

---@param options basalt.Surface
function sidebar(options) end

---@param options basalt.Surface
function boss_bar(options) end

---@param options basalt.Surface
function name_tag(options) end

---@param options basalt.Surface
function tab_list(options) end

---@param name string
---@return any
---@overload fun(name: string, implementation: table)
function service(name) end

---@param name string
---@param payload? any
---@return integer
function emit(name, payload) end

---@alias basalt.Point number[]
---@alias basalt.BoxFields { min_x: number, min_y: number, min_z: number, max_x: number, max_y: number, max_z: number }
---@alias basalt.HitCandidate { min_x: number, min_y: number, min_z: number, max_x: number, max_y: number, max_z: number, pick_radius?: number, pick_from_inside?: boolean, root?: integer }

---@class basalt.breeding
breeding = {}

---Vanilla horse offspring attribute from two parent values, the attribute range and three random draws in [0, 1).
---@param parent_a number
---@param parent_b number
---@param min number
---@param max number
---@param first number
---@param second number
---@param third number
---@return number
function breeding.offspring_attribute(parent_a, parent_b, min, max, first, second, third) end

---@class basalt.enchantments
enchantments = {}

---The value of an enchantment level based number (a bare number or a table with `type`: constant, linear, levels_squared, clamped, fraction, exponent or lookup) at a level.
---@param spec number|table
---@param level integer
---@return number
function enchantments.level_value(spec, level) end

---@class basalt.combat
combat = {}

---Damage left after armor and toughness, with the bonus fraction a weapon can add to the armor's share.
---@param damage number
---@param armor number
---@param toughness number
---@param fraction_add? number
---@return number
function combat.after_armor(damage, armor, toughness, fraction_add) end

---Damage left after enchantment protection points (capped at 20).
---@param damage number
---@param protection number
---@return number
function combat.after_protection(damage, protection) end

---Damage left under the Resistance effect of an amplifier (0 is level one).
---@param damage number
---@param amplifier integer
---@return number
function combat.after_resistance(damage, amplifier) end

---Damage after the difficulty scales it (`peaceful`, `easy`, `normal`, `hard`).
---@param damage number
---@param difficulty string
---@return number
function combat.after_difficulty(damage, difficulty) end

---Splits a hit between the absorption hearts and health: the health that is lost and the absorption that is left.
---@param damage number
---@param absorption number
---@return number health
---@return number absorption
function combat.absorb(damage, absorption) end

---The fall damage for a distance and the safe distance (3 by default).
---@param distance number
---@param safe? number
---@return integer
function combat.fall_damage(distance, safe) end

---Whether a damage type's scaling (`never`, `always` or `when_caused_by_living_non_player`) makes the difficulty change the damage.
---@param scaling string
---@param caused_by_living_non_player? boolean
---@return boolean
function combat.scales_with_difficulty(scaling, caused_by_living_non_player) end

---@class basalt.physics
physics = {}

---The first point of the segment from a point to another that is inside the box, or nil when it misses.
---@param box basalt.BoxFields
---@param from basalt.Point
---@param to basalt.Point
---@return basalt.Point?
function physics.clip(box, from, to) end

---Sweeps a box through the colliders (boxes with an optional `shape` number, the exit happens between shapes) and returns the movement that is left: Y first, then the longer of X and Z.
---@param colliders basalt.HitCandidate[]
---@param box basalt.BoxFields
---@param movement basalt.Point
---@return basalt.Point
function physics.collide(colliders, box, movement) end

---The movement of a step up over the colliders: the first rise, shortest first, whose horizontal reach beats `reach_squared`; nil when none does.
---@param colliders basalt.HitCandidate[]
---@param grounded basalt.BoxFields
---@param grounded_offset_y number
---@param movement basalt.Point
---@param max_up_step number
---@param reach_squared number
---@return basalt.Point?
function physics.step_up(colliders, grounded, grounded_offset_y, movement, max_up_step, reach_squared) end

---The projectile rotation that turns towards the movement: x_rot_o, y_rot_o, x_rot and y_rot, or nil at rest.
---@param motion basalt.Point
---@param x_rot_o number
---@param y_rot_o number
---@param x_rot number
---@param y_rot number
---@param speed number
---@return { x_rot_o: number, y_rot_o: number, x_rot: number, y_rot: number }?
function physics.rotate_towards_movement(motion, x_rot_o, y_rot_o, x_rot, y_rot, speed) end

---The closest candidate that a projectile segment hits once the boxes grow by the margin: its 1-based index and the point, or nil.
---@param candidates basalt.HitCandidate[]
---@param from basalt.Point
---@param to basalt.Point
---@param margin number
---@return integer? index
---@return basalt.Point? point
function physics.closest_hit(candidates, from, to, margin) end

---The entity a segment picks, which prefers entities of another vehicle than the root one: its 1-based index and the point, or nil.
---@param candidates basalt.HitCandidate[]
---@param root integer
---@param from basalt.Point
---@param to basalt.Point
---@param max number
---@return integer? index
---@return basalt.Point? point
function physics.picked_hit(candidates, root, from, to, max) end

---The margin an entity at that age adds to the box a projectile can hit.
---@param tick_count integer
---@return number
function physics.projectile_margin(tick_count) end

---The box a shulker peeks into, for a size, the direction ordinal (down, up, north, south, west, east), the progress range and the position.
---@param size number
---@param direction integer
---@param progress_from number
---@param progress_to number
---@param position basalt.Point
---@return basalt.BoxFields
function physics.shulker_box(size, direction, progress_from, progress_to, position) end

---The share of the spin a leashed entity keeps each tick.
---@param on_ground boolean
---@param block_friction? number
---@param in_liquid? boolean
---@return number
function physics.leash_angular_friction(on_ground, block_friction, in_liquid) end

---The pull of a taut leash on the entity: the torque and the push to add to its movement, or nil when it is slack. Bodies are `{ position, width, height, yaw }` and the motions are points.
---@param spec { self: { position: basalt.Point, width: number, height: number, yaw: number }, holder: { position: basalt.Point, width: number, height: number, yaw: number }, quad?: boolean, slack?: number, self_motion: basalt.Point, holder_motion: basalt.Point, known_motion: basalt.Point }
---@return { torque: number, push: basalt.Point }?
function physics.leash_pull(spec) end

---@class basalt.players
players = {}

---@return basalt.Player[]
function players.online() end

---@param name string
---@return basalt.Player?
function players.by_name(name) end

---@param uuid string
---@return basalt.Player?
function players.by_uuid(uuid) end

---@return integer
function players.count() end

---@class basalt.worlds
worlds = {}

---@param options { name: string, dimension?: string, type?: string, seed?: integer }
---@return basalt.World?
function worlds.create(options) end

---@return basalt.World[]
function worlds.all() end

---@param name string
---@return basalt.World?
function worlds.by_name(name) end

---@return basalt.World
function worlds.default() end

---A block state as `minecraft:oak_stairs[facing=east]` to its id, or -1.
---@param text string
---@return integer
function worlds.state_id(text) end

---The reverse of `worlds.state_id`; empty for an id that is not a state.
---@param id integer
---@return string
function worlds.state_text(id) end

---The biome names, in registry order.
---@return string[]
function worlds.biomes() end

---Every block with the id of its first state and how many states it has.
---@return { name: string, first_state: integer, state_count: integer }[]
function worlds.blocks() end

---The properties of a block in the order their values step the state id, each with the values it can take.
---@param block string
---@return { name: string, values: string[] }[]
function worlds.block_properties(block) end

---Boolean facts about a state (`blocks_motion`, `occludes`, `air`...) plus `light_emission` and `light_opacity`.
---@param id integer
---@return table<string, boolean|integer>
function worlds.state_flags(id) end

---Destroy time, explosion resistance and whether the right tool is needed; nil for an unknown block.
---@param block string
---@return { destroy_time: number, explosion_resistance: number, needs_tool: boolean }?
function worlds.block_hardness(block) end

---Physical facts about a state: friction, speed and jump factors, piston reaction, map colour and fire odds.
---@param id integer
---@return { friction: number, speed_factor: number, jump_factor: number, push_reaction: string, map_color: integer, ignite_odds: number, burn_odds: number }?
function worlds.block_info(id) end

---The collision boxes of a block state as a flat list, six numbers per box (min corner, then max corner) in blocks.
---@param id integer
---@return number[]
function worlds.block_shape(id) end

---Which blocks own a block entity: block id to the id of its block entity type.
---@return table<string, string>
function worlds.block_entity_types() end

---The world data version this server writes, the number saved data is upgraded to.
---@return integer
function worlds.data_version() end

---Upgrades a `chunk`, `block_entity`, `entity` or `item` from `from_version` to the current data version; SNBT or nil.
---@param kind "chunk"|"block_entity"|"entity"|"item"
---@param snbt string
---@param from_version integer
---@return string?
function worlds.fix_nbt(kind, snbt, from_version) end

---Upgrades a `block_state`, `item` id or `biome` id written at `from_version`; nil for another kind.
---@param kind "block_state"|"item"|"biome"
---@param text string
---@param from_version integer
---@return string?
function worlds.fix_name(kind, text, from_version) end

---The item ids, in registry order.
---@return string[]
function worlds.items() end

---The entity type ids.
---@return string[]
function worlds.entity_types() end

---The ids of a registry by name, such as `damage_type`, `particle_type` or `worldgen/biome`. Empty when the server has none.
---@param registry string
---@return string[]
function worlds.registry(registry) end

---The data a client-synced registry holds for one entry, such as `damage_type`, `jukebox_song`, `instrument` or `wolf_variant`.
---@param registry string
---@param id string
---@return string?
function worlds.registry_data(registry, id) end

---The tags of `blocks`, `items`, `fluids` or `entity_types`: tag id to its member ids.
---@param registry string
---@return table<string, string[]>
function worlds.tags(registry) end

---The sound type of a block state, with sound ids namespaced.
---@param state integer
---@return { volume: number, pitch: number, break: string, step: string, place: string, hit: string, fall: string }?
function worlds.block_sounds(state) end

---The note block instrument over a state, such as `harp`, `basedrum`, `bell` or `pling`.
---@param state integer
---@return string?
function worlds.block_instrument(state) end

---Whether the item (empty for a hand) is right for the drops of the state, and how fast it mines it.
---@param item string
---@param state integer
---@return { correct_for_drops: boolean, mining_speed: number }?
function worlds.tool_facts(item, state) end

---The state after a mirror (0 none, 1 left-right, 2 front-back) and quarter turns clockwise (0 to 3), as structure templates apply them.
---@param state integer
---@param rotation integer
---@param mirror integer
---@return integer
function worlds.transform_state(state, rotation, mirror) end

---Game rule names to `{ type, default }`.
---@return table<string, { type: string, default: string }>
function worlds.game_rules() end

---Takes a world that holds no player out of play; false for the default world or one with players. `worlds.create` brings it back.
---@param world basalt.World|string
---@param save? boolean
---@return boolean
function worlds.unload(world, save) end

---Server settings.
---@class basalt.settings
settings = {}

---The readable keys; `hide_online_players`, `level_type`, `initial_enabled_packs`, `initial_disabled_packs`, `allow_nether` and `allow_end` are read only.
---@return string[]
function settings.keys() end

---The setting as text; booleans are `true` or `false`.
---@param key string
---@return string?
function settings.get(key) end

---Writable while running: `motd`, `max_players`, `idle_timeout` (minutes), `gamemode`, `pause_when_empty_seconds`, `spawn_protection`, `pause_allowed`, `respawn_world` and `autosave`; false for anything else.
---@param key string
---@param value string|number|boolean
---@return boolean
function settings.set(key, value) end

---Recipes in the datapack's own JSON format.
---@class basalt.recipes
recipes = {}

---Registers a recipe; false when the id is taken or the JSON is not a recipe.
---@param id string
---@param json string
---@return boolean
function recipes.add(id, json) end

---Takes a recipe, the server's own included, out of every lookup.
---@param id string
---@return boolean
function recipes.remove(id) end

---@param id string
---@return boolean
function recipes.has(id) end

---Every recipe id: the datapack's first, then the added ones.
---@return string[]
function recipes.ids() end

---Empties the list.
function recipes.clear() end

---Puts back the datapack's recipes and drops the added ones.
function recipes.reset() end

---Drops the brewing recipes a plugin added and brings back the ones the game ships.
function recipes.reset_brewing() end

---Offline players, operators, the whitelist and bans.
---@class basalt.access
access = {}

---@param who basalt.Player|string A player, uuid or name.
---@return boolean
function access.is_banned(who) end

---@param who basalt.Player|string
---@return boolean
function access.is_whitelisted(who) end

---@param who basalt.Player|string
---@return boolean
function access.is_operator(who) end

---@param name string
---@return { uuid: string, name: string, first_seen: integer, last_seen: integer }?
function access.known(name) end

---A stored statistic counter of a player who may be offline, such as `minecraft:custom/minecraft:jump`.
---@param uuid string
---@param key string
---@return integer
function access.statistic(uuid, key) end

---@param uuid string
---@param key string
---@param value integer
---@return boolean
function access.set_statistic(uuid, key, value) end

---Where the player last died.
---@param uuid string
---@return { dimension: string, x: integer, y: integer, z: integer }?
function access.last_death(uuid) end

---Scoreboards; a board is an integer handle and 0 is the server board. Text arguments are MiniMessage.
---@class basalt.scoreboards
scoreboards = {}

---@alias basalt.TeamOptions { display_name?: string, prefix?: string, suffix?: string, color?: string, friendly_fire?: boolean, see_invisible?: boolean, name_tags?: string, death_messages?: string, collision?: string }

---@return integer
function scoreboards.main() end

---Makes a board of the plugin's own.
---@return integer
function scoreboards.create() end

---@param board integer
function scoreboards.release(board) end

---@param board integer
---@return string[]
function scoreboards.objectives(board) end

---@param board integer
---@param name string
---@param criterion? string
---@param title? string
---@param hearts? boolean
function scoreboards.objective_add(board, name, criterion, title, hearts) end

---@param board integer
---@param name string
function scoreboards.objective_remove(board, name) end

---With a nil third argument it returns the objective shown in the slot.
---@param board integer
---@param slot "list"|"sidebar"|"below_name"|string
---@param name? string|false
---@return string?
function scoreboards.display(board, slot, name) end

---@param board integer
---@param entry string
---@param objective string
---@return integer?
function scoreboards.score(board, entry, objective) end

---@param board integer
---@param entry string
---@param objective string
---@param value integer
function scoreboards.set_score(board, entry, objective, value) end

---@param board integer
---@param entry string
---@param objective? string
function scoreboards.reset_score(board, entry, objective) end

---@param board integer
---@return string[]
function scoreboards.entries(board) end

---@param board integer
---@return string[]
function scoreboards.teams(board) end

---@param board integer
---@param name string
function scoreboards.team_add(board, name) end

---@param board integer
---@param name string
function scoreboards.team_remove(board, name) end

---@param board integer
---@param name string
---@param options basalt.TeamOptions
function scoreboards.team_set(board, name, options) end

---@param board integer
---@param team string
---@param entry string
function scoreboards.team_join(board, team, entry) end

---@param board integer
---@param team string
---@param entry string
function scoreboards.team_leave(board, team, entry) end

---@param board integer
---@param entry string
---@return string?
function scoreboards.team_of(board, entry) end

---Draws a board for a player; with a nil board it returns the one shown.
---@param player basalt.Player
---@param board? integer
---@return integer?
function scoreboards.show(player, board) end

---@alias basalt.BossBarOptions { title?: string, color?: string, style?: string, progress?: number, key?: string, darken_sky?: boolean, boss_music?: boolean, fog?: boolean, visible?: boolean }

---Boss bars; a bar created with a `key` is kept like `/bossbar` ones.
---@class basalt.boss_bars
boss_bars = {}

---@param options basalt.BossBarOptions
---@return string? id nil when the bar cannot be made
function boss_bars.create(options) end

---@param id string
---@param options basalt.BossBarOptions
function boss_bars.update(id, options) end

---@param id string
function boss_bars.remove(id) end

---@param id string
---@param player basalt.Player
function boss_bars.add_player(id, player) end

---@param id string
---@param player basalt.Player
function boss_bars.remove_player(id, player) end

---@param id string
---@return string[]
function boss_bars.players(id) end

---@return string[]
function boss_bars.kept() end

---@class basalt.advancements
advancements = {}

---@return string[]
function advancements.ids() end

---@param id string
---@return { id: string, parent: string?, root: string, criteria: string[], children: string[], frame: string, icon: string }?
function advancements.info(id) end

---@param player basalt.Player
---@param id string
---@param criterion string
---@return boolean
function advancements.grant(player, id, criterion) end

---@param player basalt.Player
---@param id string
---@param criterion string
---@return boolean
function advancements.revoke(player, id, criterion) end

---Criterion to the time it was obtained, in milliseconds.
---@param player basalt.Player
---@param id string
---@return table<string, integer>
function advancements.progress(player, id) end

---The `/tick` machinery.
---@class basalt.tick
tick = {}

---@return number
function tick.rate() end

---@param rate number
function tick.set_rate(rate) end

---Reads the freeze state, or sets it.
---@param frozen? boolean
---@return boolean
function tick.frozen(frozen) end

---@param count integer
function tick.step(count) end

---@param count integer
function tick.sprint(count) end

function tick.stop_sprint() end

---@return { tps_1m: number, tps_5m: number, tps_15m: number, mean_tick_ms: number }
function tick.pace() end

---The last hundred tick durations in nanoseconds, not sorted by age.
---@return integer[]
function tick.times() end

---True while nobody has been online for `pause_when_empty_seconds`.
---@return boolean
function tick.paused() end

---Links of the client's pause menu, read at login.
---@class basalt.server_links
server_links = {}

---@alias basalt.ServerLink { kind?: "bug_report"|"community_guidelines"|"support"|"status"|"feedback"|"community"|"website"|"forums"|"news"|"announcements", label?: string, url: string }

---@return basalt.ServerLink[]
function server_links.list() end

---A link without a kind carries a JSON `label`.
---@param links basalt.ServerLink[]
function server_links.set(links) end

---@class basalt.datapacks
datapacks = {}

---@return { id: string, enabled: boolean, required: boolean, compatibility: string, source: string }[]
function datapacks.list() end

function datapacks.refresh() end

---The bytes of a file of the enabled data packs by its full name (`data/minecraft/recipe/stick.json`), top pack first.
---@param name string
---@return string?
function datapacks.resource(name) end

---Names of the visible data pack files that start with a prefix.
---@param prefix? string
---@return string[]
function datapacks.resources(prefix) end

---Id of the data pack a visible file comes from.
---@param name string
---@return string?
function datapacks.resource_pack(name) end

---@class basalt.loot
loot = {}

---@return string[]
function loot.tables() end

---Seed 0 rolls without a fixed seed; `looter` is a uuid.
---@param table string
---@param context? { world?: string, x?: number, y?: number, z?: number, luck?: number, seed?: integer, looter?: string }
---@return { item: string, count: integer, components: string }[]
function loot.roll(table, context) end

---Rolls a loot table given as JSON (the format of a loot table file) instead of a registered id.
---@param json string
---@param context? { world?: string, x?: number, y?: number, z?: number, luck?: number, seed?: integer, looter?: string }
---@return { item: string, count: integer, components: string }[]
function loot.roll_json(json, context) end

---Evaluates a number provider given as JSON with an empty context; `float` picks a float provider over an int one.
---@param json string
---@param options? { float?: boolean, seed?: integer }
---@return number?
function loot.number(json, options) end

---Rolls enchantments onto a stack as the `enchant_with_levels` loot function does; `options` is an enchantment id or a tag with a leading `#`.
---@param spec { item: string, count?: integer, components?: string, levels?: integer, options?: string, seed?: integer, world?: string }
---@return { item: string, count: integer, components: string }?
function loot.enchant(spec) end

---@class basalt.trades
trades = {}

---Rolls the trades a villager of a profession offers at a level (1 to 5), as a villager of that level would; `variant` is the villager type the conditions see. With `listed` (trade ids) it draws `amount` of those without repeats instead.
---@param profession string
---@param level integer
---@param context? { world?: string, x?: number, y?: number, z?: number, variant?: string, amount?: integer, seed?: integer, listed?: string[] }
---@return { cost_a: { item: string, count: integer, components: string }, cost_b?: { item: string, count: integer, components: string }, result: { item: string, count: integer, components: string }, max_uses: integer, xp: integer, price_multiplier: number }[]?
function trades.roll(profession, level, context) end

---@class basalt.maps
maps = {}

---@param world string
---@param center_x integer
---@param center_z integer
---@param scale integer
---@return integer id
function maps.create(world, center_x, center_z, scale) end

---@param id integer
---@return { dimension: string, scale: integer, center_x: integer, center_z: integer, locked: boolean }?
function maps.info(id) end

---Item components (SNBT) of a filled map pointing at the nearest of the structures; destinations are ids or tags with a leading `#`. Nil when none is found.
---@param spec { world: string, x: number, y?: number, z: number, destination: string[], decoration?: string, zoom?: integer, radius?: integer, skip_existing?: boolean }
---@return string?
function maps.explorer(spec) end

---Structure templates in the structure file format, given to and from Lua as SNBT.
---@class basalt.structures
structures = {}

---@return string[]
function structures.ids() end

---@param id string
---@return string?
function structures.read(id) end

---Keeps a template under the id; `to_disk` also saves it in the world's generated folder.
---@param id string
---@param snbt string
---@param to_disk? boolean
---@return boolean
function structures.write(id, snbt, to_disk) end

---@param id string
---@param from_disk? boolean
---@return boolean
function structures.remove(id, from_disk) end

---The generated file path an id is saved to.
---@param id string
---@return string
function structures.file(id) end

---@param box { world: string, x: integer, y: integer, z: integer, size_x: integer, size_y: integer, size_z: integer, entities?: boolean }
---@return string?
function structures.capture(box) end

---@param snbt string
---@param at { world: string, x: integer, y: integer, z: integer, rotation?: integer, mirror?: integer, integrity?: number, seed?: integer, entities?: boolean, palette?: integer }
---@return boolean
function structures.place(snbt, at) end

---@class basalt.log
log = {}

---@param message string
function log.info(message) end

---@param message string
function log.warn(message) end

---@param message string
function log.error(message) end

---@class basalt.plugin
---@field id string
---@field name string
---@field version string
---@field lane integer
---@field lanes integer
plugin = {}

---@type table<string, any>
config = {}

---@class basalt.files
files = {}

---@param path string
---@return string?
function files.read(path) end

---@param path string
---@return boolean
function files.exists(path) end

---@param path? string
---@return string[]
function files.list(path) end

---@param path string
---@param text string
---@return boolean
function files.write(path, text) end

---@class basalt.Packet
---@field name string The vanilla name, such as `clientbound.set_title_text`.
---@field serverbound boolean
---@field phase "handshake"|"status"|"login"|"configuration"|"play"
---@field id integer
---@field connection integer
---@field protocol integer The protocol version the client announced; 0 before the handshake.
---@field translated boolean True when the client is older than the server and the bytes are in the server's shape.
---@field size integer
---@field player_name string
---@field player_uuid string
---@field player basalt.Player?
---@field cancelled boolean Setting it to true cancels the packet (not on `packet.watch`).
---@field bytes integer[] The body without the id; assigning a list replaces it.
local Packet = {}

function Packet:cancel() end

---Sends another clientbound packet on this connection, past the listeners unless asked.
---@param name string
---@param bytes integer[]
---@param intercept? boolean
---@return boolean
function Packet:send(name, bytes, intercept) end

---Hands a serverbound packet to the server as if the client had sent it.
---@param name string
---@param bytes integer[]
---@param intercept? boolean
---@return boolean
function Packet:receive(name, bytes, intercept) end

---Needs `packets = true` under `[capabilities]` in plugin.toml and the permission to be granted.
---@class basalt.packet
packet = {}

---Listens to packets of any state; a name is `clientbound.set_title_text`, `serverbound.play.*` or similar.
---@param name string
---@param options { priority?: "first"|"early"|"normal"|"late"|"last" }|fun(p: basalt.Packet)
---@param handler? fun(p: basalt.Packet)
function packet.on(name, options, handler) end

---Like `packet.on`, but it only observes: it cannot cancel or edit.
---@param name string
---@param options { priority?: "first"|"early"|"normal"|"late"|"last" }|fun(p: basalt.Packet)
---@param handler? fun(p: basalt.Packet)
function packet.watch(name, options, handler) end

---Sends a clientbound packet to a player.
---@param player basalt.Player|string
---@param name string
---@param bytes integer[]
---@param intercept? boolean Run the listeners on it (default false).
---@return boolean
function packet.send(player, name, bytes, intercept) end

---Handles a serverbound packet as if that player's client had sent it.
---@param player basalt.Player|string
---@param name string
---@param bytes integer[]
---@param intercept? boolean
---@return boolean
function packet.receive(player, name, bytes, intercept) end

---Plugin message channels; the plugin declares them in `network` under `[capabilities]`.
---@class basalt.channel
channel = {}

---@param name string
---@param fn fun(player: basalt.Player, bytes: integer[])
function channel.on(name, fn) end

---@param player basalt.Player|string
---@param name string
---@param bytes integer[]
---@return boolean
function channel.send(player, name, bytes) end

---Runs a command as the console. Needs `commands = true` under `[capabilities]`.
---@param command string
---@return boolean
function run(command) end
