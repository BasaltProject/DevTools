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
---@field pos basalt.Position
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
local World = {}

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
