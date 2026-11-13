---@meta
-- Hand-written types for the proxy calls whose shape is richer than the generated `...`.

---@class basalt.Packet
---@field name string The vanilla name, such as `clientbound.set_title_text`.
---@field serverbound boolean True when the client sent it toward the backend.
---@field phase "login"|"configuration"|"play"
---@field id integer
---@field connection integer
---@field protocol integer The protocol version the client announced.
---@field backend_protocol integer The protocol version of the backend the packet goes to or comes from; 0 before one is chosen.
---@field backend string The backend the packet goes to or comes from; empty before one is chosen.
---@field translated boolean True when a side is not 26.3 and the bytes are in the 26.3 shape the proxy works in.
---@field size integer
---@field player_name string
---@field player_uuid string
---@field player basalt.Player?
---@field editable boolean False for login packets and the ones the proxy answers itself (keep alive, cookies, resource packs, transfer, configuration changes): they can be read but not cancelled or edited.
---@field cancelled boolean Setting it to true cancels the packet (not on `packet.watch`).
---@field bytes integer[] The body without the id; assigning a list replaces it.
local Packet = {}

function Packet:cancel() end

---Sends another clientbound packet to the client, past the listeners unless asked; it must be of the connection's current phase.
---@param name string
---@param bytes integer[]
---@param intercept? boolean
---@return boolean
function Packet:send(name, bytes, intercept) end

---Hands a serverbound packet to the backend as if the client had sent it.
---@param name string
---@param bytes integer[]
---@param intercept? boolean
---@return boolean
function Packet:receive(name, bytes, intercept) end

---Needs `packets = true` under `[capabilities]` in plugin.toml and the permission to be granted under `[plugins.allow]` in proxy.toml.
---@class basalt.Player
---@field name string
---@field uuid string
---@field server string The backend the player is on; empty before one is chosen.
---@field settings basalt.PlayerSettings? What the client last said about itself; nil until it sends its client information.
local Player = {}

---@class basalt.PlayerSettings
---@field locale string Such as `en_us`.
---@field view_distance integer
---@field chat_mode "full"|"system"|"hidden"
---@field chat_colors boolean
---@field skin_parts integer Bit mask: cape 1, jacket 2, left sleeve 4, right sleeve 8, left leg 16, right leg 32, hat 64.
---@field main_hand "left"|"right"
---@field text_filtering boolean
---@field server_listing boolean
---@field particles "all"|"decreased"|"minimal"

---Shows a title and subtitle (MiniMessage text); the times are in ticks and apply when all three are given.
---@param title string?
---@param subtitle string?
---@param fade_in integer?
---@param stay integer?
---@param fade_out integer?
---@return boolean
function Player:title(title, subtitle, fade_in, stay, fade_out) end

---Clears the title; with `reset` the timings go back to their defaults too.
---@param reset boolean?
---@return boolean
function Player:clear_title(reset) end

---@param text string
---@return boolean
function Player:action_bar(text) end

---Sets the tab list header and footer; nil leaves a part empty.
---@param header string?
---@param footer string?
---@return boolean
function Player:tab_list(header, footer) end

---Shows a boss bar the plugin names; `color` is pink, blue, red, green, yellow, purple or white, `overlay` progress or notched_6, 10, 12, 20.
---@param id string
---@param text string
---@param progress number 0 to 1
---@param color string?
---@param overlay string?
---@return boolean
function Player:show_bossbar(id, text, progress, color, overlay) end

---@param id string
---@return boolean
function Player:hide_bossbar(id) end

---@param id string
---@param progress number
---@return boolean
function Player:bossbar_progress(id, progress) end

---@param id string
---@param text string
---@return boolean
function Player:bossbar_title(id, text) end

---@param id string
---@param color string
---@param overlay string
---@return boolean
function Player:bossbar_style(id, color, overlay) end

---Shows the proxy's own sidebar: a title and up to 15 lines, top to bottom.
---@param title string
---@param ... string
---@return boolean
function Player:sidebar(title, ...) end

---@return boolean
function Player:clear_sidebar() end

---Adds a row to this player's tab list, or updates it; `id` names it for the plugin, `name` is the profile name (up to 16 characters).
---@param id string
---@param name string
---@param text string
---@param latency integer?
---@return boolean
function Player:tab_entry(id, name, text, latency) end

---@param id string
---@return boolean
function Player:remove_tab_entry(id) end

---Overrides one permission node for this player until the proxy stops; nil removes the override.
---@param node string
---@param granted boolean?
function Player:set_permission(node, granted) end

---The name of the player's proxy group.
---@return string
function Player:group() end

---Puts the player in a group of groups.toml, or in none when nil; false when that is not possible.
---@param group string?
---@return boolean
function Player:set_group(group) end

---The permission patterns the player's group chain and overrides grant.
---@return string[]
function Player:permissions() end

---Shows a dialog in play or configuration; `kind` is notice, confirmation (exactly two buttons) or multi_action; every button is a label and the command it runs as the player.
---@param kind "notice"|"confirmation"|"multi_action"
---@param title string
---@param body string?
---@param ... string label, command, label, command, ...
---@return boolean
function Player:dialog(kind, title, body, ...) end

---@return boolean
function Player:clear_dialog() end

---Makes the player say a line, or run it as a command when it starts with a slash; sent unsigned.
---@param text string
---@return boolean
function Player:chat(text) end

---Moves the client to another host with a transfer packet.
---@param host string
---@param port integer
---@return boolean
function Player:transfer(host, port) end

---Stores a cookie on the client under a namespaced key.
---@param key string
---@param data string
---@return boolean
function Player:set_cookie(key, data) end

---Asks the client for a cookie; the callback gets its data, or nil when it has none or does not answer.
---@param key string
---@param callback fun(data: string?)
---@return boolean
function Player:cookie(key, callback) end

---Sets the links of the client's pause menu: pairs of a label and a URL. A label that is a known type (report_bug, community_guidelines, support, status, feedback, community, website, forums, news, announcements) is translated by the client; any other is MiniMessage text. No pairs clears them.
---@param ... string label, url, label, url, ...
---@return boolean
function Player:server_links(...) end

---Changes the words the client offers when completing chat.
---@param action "add"|"remove"|"set"
---@param ... string
---@return boolean
function Player:chat_completions(action, ...) end

---Offers a resource pack; plugin packs stay on the client across server changes. `id` names it (a UUID or any text; the URL when nil). Returns the pack's UUID, or nil when the proxy refused it. Statuses arrive as `player.resource_pack` events.
---@param url string
---@param hash string? SHA-1 as 40 hex digits.
---@param required boolean?
---@param prompt string? MiniMessage text.
---@param id string?
---@return string?
function Player:resource_pack(url, hash, required, prompt, id) end

---Takes back a pack this or another plugin offered, by the id given to resource_pack or the UUID it returned.
---@param id string
---@return boolean
function Player:remove_resource_pack(id) end

---Takes back every pack plugins offered; the backend's stay.
---@return boolean
function Player:clear_resource_packs() end

---@class basalt.event.player_resource_pack
---@field player basalt.Player
---@field player_name string
---@field id string The pack's UUID.
---@field status "successfully_loaded"|"declined"|"failed_download"|"accepted"|"downloaded"|"invalid_url"|"failed_reload"|"discarded"

---@class basalt.ServerPing
---@field motd string The description as plain text.
---@field motd_json string The description as component JSON.
---@field online integer
---@field max_players integer
---@field version string
---@field protocol integer
---@field latency integer Milliseconds the answer took.

---@class basalt.servers
servers = {}

---Asks a configured server for its server list status; the callback gets the answer, or nil when it did not answer. False when the server is not configured.
---@param name string
---@param callback fun(answer: basalt.ServerPing?)
---@return boolean
function servers.ping(name, callback) end

---Adds a server until the proxy stops, never written to servers.toml. It copies forwarding, protocol and plugin messages from `like`, or from the first default server. A server of the same name later added to servers.toml replaces it on reload. Returns false and the reason when it cannot.
---@param name string
---@param host string
---@param port integer?
---@param like string?
---@return boolean ok
---@return string? reason
function servers.register(name, host, port, like) end

---Removes a server added with servers.register; false for the ones of servers.toml.
---@param name string
---@return boolean
function servers.unregister(name) end

---@class basalt.packet
packet = {}

---Listens to packets as the proxy relays them; a name is `clientbound.set_title_text`, `serverbound.play.*` or similar. `fail = "closed"` cancels the packet when the plugin interpreter is too busy to run the listener (default "open" lets it pass).$
---@param name string
---@param options { priority?: "first"|"early"|"normal"|"late"|"last", fail?: "open"|"closed" }|fun(p: basalt.Packet)
---@param handler? fun(p: basalt.Packet)
function packet.on(name, options, handler) end

---Like `packet.on`, but it only observes: it cannot cancel or edit.
---@param name string
---@param options { priority?: "first"|"early"|"normal"|"late"|"last", fail?: "open"|"closed" }|fun(p: basalt.Packet)
---@param handler? fun(p: basalt.Packet)
function packet.watch(name, options, handler) end

---Sends a clientbound packet to a player's client.
---@param player { name: string }|string
---@param name string
---@param bytes integer[]
---@param intercept? boolean Unused: a packet sent this way never runs the listeners.
---@return boolean
function packet.send(player, name, bytes, intercept) end

---Hands a serverbound packet to the player's backend as if the client had sent it.
---@param player { name: string }|string
---@param name string
---@param bytes integer[]
---@param intercept? boolean Unused: a packet sent this way never runs the listeners.
---@return boolean
function packet.receive(player, name, bytes, intercept) end

---Bans an address in the antibot; true when the ban was recorded.
---@param address string
---@return boolean
function antibot.ban(address) end

---Lifts an antibot ban; true when the address was banned.
---@param address string
---@return boolean
function antibot.unban(address) end

---Marks a player as verified, so the antibot lets them in without a check.
---@param player string
function antibot.verify(player) end

---Removes the verified mark of a player.
---@param player string
function antibot.unverify(player) end

---True when the player is marked as verified.
---@param player string
---@return boolean
function antibot.is_verified(player) end

---True while the antibot is in attack mode.
---@return boolean
function antibot.under_attack() end
