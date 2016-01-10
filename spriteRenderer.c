#include <stdio.h>
#include <stdlib.h>
#include <GL/gl.h>
#include <GL/glext.h>

const char *VERTEX_SHADER = 
	"#version 130\n"

	"attribute vec2 position;"

	"varying vec2 texcoords;"

	"uniform mat4 modelTransform;"
	"uniform mat4 viewProjectionTransform;"
	"uniform vec2 scale;"
	"uniform vec2 vertexOffset;"
	"uniform float[4] texcoordsOffset;"
	"void main() {"
		"texcoords = vec2(texcoordsOffset[int(position.x * 2)], texcoordsOffset[int(position.y * 2.0 + 1.0)]);"
		"gl_Position = viewProjectionTransform * modelTransform * vec4((position.x + vertexOffset.x) * scale.x, (position.y + vertexOffset.y) * scale.y, 0.0, 1.0);"
	"}";

const char *FRAGMENT_SHADER = 
	"#version 130\n"

	"varying vec2 texcoords;"

	"uniform sampler2D sampler;"
	"uniform float[4] texcoordsOffset;"
	"uniform vec4 color;"
	"uniform int useTexture;"

	"void main() {"
		"if (useTexture != 0) {"
			"gl_FragColor = texture2D(sampler, texcoords) * color;"
		"} else {"
			"gl_FragColor = color;"
		"}"
		// "gl_FragColor.rgba = gl_FragColor.bgra;"
	"}";

static void checkErrors(const char *extraMessage) {
	GLenum error;

	while ((error = glGetError()) != GL_NO_ERROR)
		printf("ERROR (%s): %u\n", extraMessage, error);
}

GLuint buffers[2];
GLuint vao;
GLuint shader;

GLint viewProjectionTransformUniform;
GLint modelTransformUniform;
GLint scaleUniform;
GLint textureUniform;
GLint colorUniform;
GLint useTextureUniform;
GLint vertexOffsetUniform;
GLint texcoordsOffsetUniform;

const GLint textureIndex = 0;

static GLuint setupShader(GLenum type, const char* source) {
	int success, maxLength;
	char* infoLog;

	GLuint shader = glCreateShader(type);
	glShaderSource(shader, 1, &source, 0);
	glCompileShader(shader);

	glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
	if (success == GL_FALSE) {
	   glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &maxLength);

	   infoLog = (char *) malloc(maxLength);

	   glGetShaderInfoLog(shader, maxLength, &maxLength, infoLog);
	   printf("SHADER FAILED TO COMPILE: %s\n", infoLog);
	   free(infoLog);

	   return 0;
	}

	return shader;
}

static void setupShaders() {
	int success, maxLength;
	char *infoLog;

	GLuint vertexShader = setupShader(GL_VERTEX_SHADER, VERTEX_SHADER);
	GLuint fragmentShader = setupShader(GL_FRAGMENT_SHADER, FRAGMENT_SHADER);

	if (vertexShader == 0 || fragmentShader == 0)
		return;

	shader = glCreateProgram();
	glAttachShader(shader, vertexShader);
	glAttachShader(shader, fragmentShader);

	glBindAttribLocation(shader, 0, "position");

	glLinkProgram(shader);

	glGetProgramiv(shader, GL_LINK_STATUS, &success);
	if (success == GL_FALSE) {
		glGetProgramiv(shader, GL_INFO_LOG_LENGTH, &maxLength);

		infoLog = (char *)malloc(maxLength);

		glGetProgramInfoLog(shader, maxLength, &maxLength, infoLog);
		printf("LINKING PROGRAM FAILED: %s\n", infoLog);

		free(infoLog);
		return;
	}

	glUseProgram(shader);

	viewProjectionTransformUniform = glGetUniformLocation(shader, "viewProjectionTransform");
	modelTransformUniform = glGetUniformLocation(shader, "modelTransform");
	scaleUniform = glGetUniformLocation(shader, "scale");
	colorUniform = glGetUniformLocation(shader, "color");
	textureUniform = glGetUniformLocation(shader, "sampler");
	vertexOffsetUniform = glGetUniformLocation(shader, "vertexOffset");
	texcoordsOffsetUniform = glGetUniformLocation(shader, "texcoordsOffset");
	useTextureUniform = glGetUniformLocation(shader, "useTexture");

	checkErrors("after shader setup");
}

void setupRenderer() {
	GLuint vaos[1];

	checkErrors("on startup of spriteRenderer");

	setupShaders();

	glGenVertexArrays(1, vaos);
	vao = vaos[0];

	glBindVertexArray(vao);

	glGenBuffers(2, buffers);

	GLfloat data[] = {
		0, 0,
		1, 0,
		0, 1,
		1, 0,
		1, 1,
		0, 1
	};
	glBindBuffer(GL_ARRAY_BUFFER, buffers[0]);
	glEnableVertexAttribArray(0);
	glBufferData(GL_ARRAY_BUFFER, 12 * sizeof(GLfloat), data, GL_STATIC_DRAW);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, 0);

	glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	checkErrors("unbind");

	checkErrors("after spriteRenderer setup");
}

void beginBatch(float *viewProjectionTransform, GLboolean centeredGeometry) {
	glBindVertexArray(vao);
	glUseProgram(shader);

	float vertexOffset[2] = { 0, 0 };
	if (centeredGeometry) {
		vertexOffset[0] = -0.5;
		vertexOffset[1] = -0.5;
	}

	glActiveTexture(GL_TEXTURE0 + textureIndex);
	glUniform1iv(textureUniform, 1, &textureIndex);
	glUniform2fv(vertexOffsetUniform, 1, &vertexOffset);
	glUniformMatrix4fv(viewProjectionTransformUniform, 1, GL_TRUE, viewProjectionTransform);
}

void renderSprite(float *modelTransform, float scaleX, float scaleY, float r, float g, float b, float alpha, float *texcoordsOffset, GLboolean useTexture) {
	float scale[2] = { scaleX, scaleY };
	float color[4] = { r, g, b, alpha };

	glUniformMatrix4fv(modelTransformUniform, 1, GL_FALSE, modelTransform);
	glUniform2fv(scaleUniform, 1, scale);
	glUniform4fv(colorUniform, 1, color);

	if (useTexture)
		glUniform1fv(texcoordsOffsetUniform, 4, texcoordsOffset);
	glUniform1iv(useTextureUniform, 1, &useTexture);

	glDrawArrays(GL_TRIANGLES, 0, 6);
}

void endBatch() {
	glUseProgram(0);
	glBindVertexArray(0);
}
