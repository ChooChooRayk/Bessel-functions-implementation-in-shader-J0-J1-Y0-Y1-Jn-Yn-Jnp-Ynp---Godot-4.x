# Godot_Bessel_functions_shader
Implementation of Bessel functions of the first kind using the Godot 4.x shading language.

# Notes on the implementation
I mainly translated methods of the GSL - GNU Scientific Library (https://www.gnu.org/software/gsl/), into the Godot 4.x shading language.

# Godot project
In the godot project, there are simple nodes that aim at displaying the calculated functions by the shader, set in a material shader on a texture. On top of it, i compare the values calculated by the shader with standard values generated using the scipy package in python.

# Futur developement
I would like to implement the Bessel's function of the second kind, using complex number calculation on shader. It already exists else where but i'd like to implement it as an exercise.
