---@meta
-- Hand-written types for the names the server API gives a plugin. The generator keeps these and writes the rest.

---@alias basalt.Where basalt.Position|{ world?: string, x: number, y: number, z: number }

---@alias basalt.ItemSpec string|{ id: string, count?: integer, name?: string, lore?: string[], damage?: integer, enchantments?: table<string, integer> }

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
local Entity = {}

function Entity:remove() end

---@overload fun(self: basalt.Entity, x: number, y: number, z: number): boolean
---@param where basalt.Where
---@return boolean
function Entity:teleport(where) end

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
---@field block_version integer Moves on whenever a block changes or a chunk loads or unloads, so a copy of a section stays valid while it holds.
---@field folder string The world folder on disk, under worlds/.
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

---@overload fun(self: basalt.World, text: string, x: number, y: number, z: number): basalt.Hologram?
---@param text string
---@param where basalt.Where
---@return basalt.Hologram?
function World:hologram(text, where) end

---@param options table
---@return basalt.NPC?
function World:npc(options) end

---Block state ids of a 16 by 16 by 16 section, 4096 of them ordered x fastest, then z, then y (index = y * 256 + z * 16 + x, from 1).
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

---Writes several sections of one chunk. Returns the number of blocks that changed (nil when something was out of range), and with `previous = true` a second result mapping section_y to what that section held before.
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
---@return table<integer, table<integer, integer[]>>? previous One entry per chunk, in order, each mapping section_y to the old states.
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

---Runs what a change of blocks sets off for blocks that were already written. `effects` is a list of names (`neighbors`,
---`shapes`, `light`, `entities`, `poi`, `ticks`, `clients`, `place`, `departure`) or their bits added up. `previous`
---holds the state each position had before, which `departure` and `neighbors` use for what left.
---@param positions integer[][] { x, y, z } triples.
---@param effects? string[]|integer
---@param previous? integer[] One state id per position, or nothing for unknown.
---@return integer reached How many positions were in a loaded chunk.
function World:update_neighbors(positions, effects, previous) end

---Tells the block at each position that one of its neighbors changed (`neighborChanged`): lamps, torches, pistons, dust,
---dispensers and rails answer, and what they change is told onward. `sources` holds the state that told it, if known.
---@param positions integer[][] { x, y, z } triples.
---@param sources? integer[] One state id per position, or nothing for unknown.
---@return integer reached
function World:neighbor_changed(positions, sources) end

---Lets the blocks around each position reshape to fit it (`updateNeighbourShapes`), so fences join and torches fall off
---a missing wall. With `states`, runs `updateIndirectNeighbourShapes` for a block that is, or was, that state instead.
---@param positions integer[][] { x, y, z } triples.
---@param states? integer[] One state id per position.
---@return integer reached
function World:update_shapes(positions, states) end

---Books a tick of the block at a position, `delay` ticks away, or of the fluid in it when `kind` is `"fluid"`.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, delay: integer, kind?: "block"|"fluid"): boolean
---@param where basalt.Where
---@param delay integer
---@param kind? "block"|"fluid"
---@return boolean booked False when there is nothing to tick there.
function World:schedule_tick(where, delay, kind) end

---Uses an item on a face of the block at a position, as a player holding it and looking along `yaw` and `pitch` would.
---Only block items are placed so far; returns how many blocks were put down.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, face: string, item: string, yaw?: number, pitch?: number): integer
---@param where basalt.Where
---@param face "down"|"up"|"north"|"south"|"west"|"east"
---@param item string
---@param yaw? number
---@param pitch? number
---@return integer placed
function World:use_item_on(where, face, item, yaw, pitch) end

---Writes states at positions, then runs `effects` for the blocks that changed, as `Level.setBlock` would: `departure`
---and `place` (the old and the new block's own hooks), `ticks` (what the new block books), `neighbors`, `shapes`,
---`clients`, `light`, `poi` (points of interest follow) and `entities` (a replaced container spills its items).
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

---The light of a section as 2048 bytes, two levels each (index `y * 256 + z * 16 + x`, low nibble first); nil when
---the chunk is not loaded or the dimension has no such light.
---@param chunk_x integer
---@param section_y integer
---@param chunk_z integer
---@param layer "block"|"sky"
---@param load? boolean Load or generate the chunk (default true).
---@return string?
function World:light_section(chunk_x, section_y, chunk_z, layer, load) end

---Replaces the light of a section with 2048 bytes in the layout `light_section` gives. It stands until blocks around
---it change and the light is worked out again.
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

---Replaces the data of the block entity at a position with SNBT (id, x, y and z are ignored). False when the block owns none.
---@overload fun(self: basalt.World, x: integer, y: integer, z: integer, snbt: string): boolean
---@param where basalt.Where
---@param snbt string
---@return boolean
function World:set_block_entity(where, snbt) end

---Where the block entities of a loaded chunk are.
---@param chunk_x integer
---@param chunk_z integer
---@return integer[][] positions { x, y, z } triples in world coordinates.
function World:block_entities(chunk_x, chunk_z) end

---An entity as the SNBT the world would save it as (id, Pos, Rotation, Motion, UUID...).
---@param entity basalt.Entity|integer An entity or its id.
---@return string?
function World:entity_nbt(entity) end

---Brings an entity back from the SNBT `entity_nbt` gave, with Pos changed as wanted.
---@param snbt string
---@return basalt.Entity?
function World:spawn_nbt(snbt) end

---An entity of this world by id or uuid.
---@param id integer|string
---@return basalt.Entity?
function World:entity(id) end

---The entities of a chunk, which are the ones it will save.
---@param chunk_x integer
---@param chunk_z integer
---@return basalt.Entity[]
function World:entities_in(chunk_x, chunk_z) end

---The biome names of a chunk's 4 by 4 by 4 cells for the whole height of the world (height / 4 * 16 of them), ordered (cell_y * 4 + cell_z) * 4 + cell_x from 1, cell_y counting up from the lowest block. Nil when the chunk is not loaded.
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

---Waits until a chunk is loaded, generating it in the background when `generate` is not false. A lower priority is
---served first; `urgent` is the priority of a player waiting for the chunk. Check `World:chunk_status` afterwards.
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

---Facts about a state: `blocks_motion`, `occludes`, `full_cube`, `replaceable`, `has_fluid`, `has_collision`,
---`conducts_redstone`, `ticks_randomly`, `air`, `has_block_entity`, then `light_emission` and `light_opacity`.
---@param id integer
---@return table<string, boolean|integer>
function worlds.state_flags(id) end

---Destroy time, explosion resistance and whether the right tool is needed; nil for an unknown block.
---@param block string
---@return { destroy_time: number, explosion_resistance: number, needs_tool: boolean }?
function worlds.block_hardness(block) end

---Physical facts about a state: friction, speed and jump factors, how a piston treats it (`normal`, `destroy`, `block`,
---`ignore`, `push_only`), its map colour as 0xRRGGBB, and the odds it catches fire and burns.
---@param id integer
---@return { friction: number, speed_factor: number, jump_factor: number, push_reaction: string, map_color: integer, ignite_odds: number, burn_odds: number }?
function worlds.block_info(id) end

---The item ids, in registry order.
---@return string[]
function worlds.items() end

---The entity type ids.
---@return string[]
function worlds.entity_types() end

---The tags of `blocks`, `items`, `fluids` or `entity_types`: tag id to its member ids.
---@param registry string
---@return table<string, string[]>
function worlds.tags(registry) end

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

---Sends another clientbound packet on the connection this one travels on, past the listeners unless asked.
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

---Listens to packets of any state. A name is `clientbound.set_title_text`, `serverbound.play.*` or `clientbound.configuration.0x07`.
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
