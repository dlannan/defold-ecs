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

# Basic Instructions
This is not a comprehensive set of instructions but it should be enough to get started using Tiny ECS in your project.
Hint: If, at any time, you are having problems open the example project and examine how that works.

## Setup
This is not an extension project (at the moment) so you need to copy across these folders into your project:
- defnet ( if you are already using defnet, this might be a problem. You will need to remove the extension and use this folder)
- libs
- utils
Optional folders if you want camera effects:
- lumiere (only if you want camera effects - see lumiere specific section for details)
- render (only needed if you want camera effects)

Add the ```/lib/ecs/ecs.go``` game object to your main game collection (in the root of the collection)

And that should be all thats needed for copying and setup.

## Init and Runtime

In a script in your game/application where the initial game system runs from add:

```local wm	= require("libs.ecs.world-manager")```

In the ```init(self)``` function add cameras, objects, and systems as needed. It is also fine to add and remote these entities at runtime as well. 

### **wm:addCamera( < camera_name > , < camera_url > )**

> Add a camera with the unique name camera_name and its associated url. 

> Example: ```wm:addCamera( "camera", "/camera#camera" )```

### **wm:addGameObject( < game_object_name > , < game_object_url > )**

Add a game object with the unique name game_object_name and its associated url. 

Example: ```wm:addGameObject( "cube", "/main/cube" )```

### **wm:addEntity( < entity_pos > , < entity_rot >, < entity_object > )**

Add an entity with its position, rotation, and the object table. This is different to addGameObject and allows non-Defold game objects to be added.

Example: ```wm:addEntity( position, rotation, obj )```

### **wm:removeEntity( entity_id )**

Remove and entity from the ECS. The entity id is generated and should be accessible in any entity as entity.id  

Example: ```wm:removeEntity( entity.id )```

### **wm:addSystem( < system_name > , < filter_table >, < callback_function > )**

Add a system filter passing in a unique system_name, a filter set and a callback for the filtered entities. 

Systems are described in detail in the Tiny ECS doc here: <https://bakpakin.github.io/tiny-ecs/doc/#System_functions>

More information will be added.

Example: ```wm:addSystem( "MoverProcess", { "name", "etype" }, moverUpdate)```


## Http Server

To change the Server Host and the Port for the Http Server, select the ecs.go that was added to the main collection and click on the script.
The Server Host and the Server Port can be modified and then saved. 

To access the server while the defold application is running open a browser that points to the index.html file at the set host and port. 

Example: ```http://127.0.0.1:9190/index.html```

This should also work on mobile connected to the same network. Being http this is not a secure connection, but it is intended as a debugging and configuration tool. Remember to disable the Server when releasing builds to users.

