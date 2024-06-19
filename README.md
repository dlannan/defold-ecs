# defold-ecs
An ECS library for defold with builtin http web server debugging and monitoring

The ECS system is based on Tiny ECS: https://github.com/bakpakin/tiny-ecs
Highly recommended as a simple and lightweight lua ECS lib. 

The Http Server is based on the brilliant Defnet (with a number of 'tweaks'). It is not used as a native extension dependency because of the route modifications that I needed to add to make it more suitable.
Defnet: https://github.com/britzl/defnet

Additional libs/tools can be found in the utils folder. These are my own concoctions, so use with caution :) 
The utils/transforms are particularly useful and are used heavily in many of my projects so I have some confidence in the quality of this lib :) 

To be added:
- Ozz Animation for realtime animation load/save/modify of assets
- Movie/Cust Scene building
- More complex performance analysis and some deeper debugging facilities (for the ECS).
