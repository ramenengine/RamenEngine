# Tiled Support

RAMEN comes with an optional module for loading data from Tiled maps (.tmx files), along with Tiled tilesets (.tsx files).  The Tiled module includes `tilemap.f`, which adds tilemap rendering and collision detection routines, and tilemap objects that read from a fixed buffer.  (You are able to create additional tilemap buffers, you just will have to render them yourself.)

