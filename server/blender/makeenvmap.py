import bpy
import os

print(os.path.dirname(bpy.data.filepath))

C = bpy.context

texturenode = C.scene.world.node_tree.nodes.new("ShaderNodeTexEnvironment")

imagename = 'image.exr'

imagepath = os.path.join(os.path.dirname(bpy.data.filepath), imagename)
texturenode.image = bpy.data.images.load(imagepath)

worldnode = C.scene.world.node_tree.nodes['World Output']

links = C.scene.world.node_tree.links
links.new(worldnode.inputs[0], texturenode.outputs[0])

my_areas = bpy.context.workspace.screens[0].areas
my_shading = 'RENDERED'  # 'WIREFRAME' 'SOLID' 'MATERIAL' 'RENDERED'


for area in my_areas:
    for space in area.spaces:
        if space.type == 'VIEW_3D':
            space.shading.type = my_shading