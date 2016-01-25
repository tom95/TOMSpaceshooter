#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <string.h>
#include <linux/input.h>
#include <libudev.h>

enum device_event_type {
	DEVICE_ADDED,
	DEVICE_REMOVED
};

enum event_type {
	AXIS,
	BUTTON,
	HAT
};
const char *event_type_to_string(enum event_type type)
{
	switch (type) {
		case AXIS: return "axis";
		case BUTTON: return "button";
		case HAT: return "hat";
	}
	return "unknown";
}

enum hat_position {
	HAT_LEFTUP,
	HAT_UP,
	HAT_RIGHTUP,
	HAT_LEFT,
	HAT_CENTERED,
	HAT_RIGHT,
	HAT_LEFTDOWN,
	HAT_DOWN,
	HAT_RIGHTDOWN
};

#define MAX_BUTTON_NAME_LENGTH 16
#define BUTTON_EVENT_BUFFER_SIZE 256
struct button_event {
	int button;
	int active;
	int controller_index;
	struct button_event *next;
};
int num_buffered_events = 0;
struct button_event *button_event_buffer_head;
struct button_event *button_event_buffer_tail;

const char *controller_mappings[] = {
	"03000000e82000006058000001010000,Cideko AK08b,a:b2,b:b1,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b3,y:b0,",
	"0500000047532047616d657061640000,GameStop Gamepad,a:b0,b:b1,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b2,y:b3,",
	"030000006f0e00000104000000010000,Gamestop Logic3 Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"03000000ba2200002010000001010000,Jess Technology USB Game Controller,a:b2,b:b1,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:,leftshoulder:b4,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,righttrigger:b7,rightx:a3,righty:a2,start:b9,x:b3,y:b0,",
	"030000006d04000019c2000010010000,Logitech Cordless RumblePad 2,a:b1,b:b2,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b0,y:b3,",
	"030000006d0400001dc2000014400000,Logitech F310 Gamepad (XInput),a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"030000006d0400001ec2000020200000,Logitech F510 Gamepad (XInput),a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"030000006d04000019c2000011010000,Logitech F710 Gamepad (DInput),a:b1,b:b2,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b0,y:b3,", /* Guide button doesn't seem to be sent in DInput mode. */
	"030000006d0400001fc2000005030000,Logitech F710 Gamepad (XInput),a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"030000006d04000018c2000010010000,Logitech RumblePad 2,a:b1,b:b2,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b0,y:b3,",
	"03000000550900001072000011010000,NVIDIA Controller,a:b0,b:b1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b4,leftstick:b8,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b9,righttrigger:a4,rightx:a2,righty:a3,start:b7,x:b2,y:b3,",
	"050000007e0500003003000001000000,Nintendo Wii Remote Pro Controller,a:b1,b:b0,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b2,y:b3,",
	"050000003620000100000002010000,OUYA Game Controller,a:b0,b:b3,dpdown:b9,dpleft:b10,dpright:b11,dpup:b8,guide:b14,leftshoulder:b4,leftstick:b6,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b7,righttrigger:a5,rightx:a3,righty:a4,x:b1,y:b2,",
	"030000004c0500006802000011010000,PS3 Controller,a:b14,b:b13,back:b0,dpdown:b6,dpleft:b7,dpright:b5,dpup:b4,guide:b16,leftshoulder:b10,leftstick:b1,lefttrigger:b8,leftx:a0,lefty:a1,rightshoulder:b11,rightstick:b2,righttrigger:b9,rightx:a2,righty:a3,start:b3,x:b15,y:b12,",
	"03000000341a00003608000011010000,PS3 Controller,a:b1,b:b2,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b12,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a2,righty:a3,start:b9,x:b0,y:b3,",
	"030000004c050000c405000011010000,PS4 Controller,a:b1,b:b2,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b12,leftshoulder:b4,leftstick:b10,lefttrigger:a3,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:a4,rightx:a2,righty:a5,start:b9,x:b0,y:b3,",
	"050000004c050000c405000000010000,PS4 Controller,a:b1,b:b2,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b12,leftshoulder:b4,leftstick:b10,lefttrigger:a3,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:a4,rightx:a2,righty:a5,start:b9,x:b0,y:b3,",
	"03000000c6240000045d000025010000,Razer Sabertooth,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"03000000321500000009000011010000,Razer Serval,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a4,rightx:a2,righty:a3,start:b7,x:b2,y:b3,",
	"050000003215000000090000163a0000,Razer Serval,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a4,rightx:a2,righty:a3,start:b7,x:b2,y:b3,",
	"03000000de280000fc11000001000000,Steam Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"03000000de280000ff11000001000000,Valve Streaming Gamepad,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"xinput,XInput Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	"030000005e040000d102000001010000,Xbox One Wireless Controller,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",
	NULL
};

#define GUID_SIZE 16
typedef struct { uint8_t data[GUID_SIZE]; } GUID_t;

struct controller {
	int fd;
	char* path;
	char *name;
	GUID_t guid;

	int nhats;

	int nbuttons;
	uint8_t keymap[KEY_MAX - BTN_MISC];

	int naxes;
	uint8_t abs_map[ABS_MAX];
	struct axis_correct
	{
		int used;
		int coef[3];
	} abs_correct[ABS_MAX];

	struct hat
	{
		int axis[2];
	} *hats;

	// mapping from a button index into the state struct
	int axis_mappings[ABS_MAX];
	char button_mappings[KEY_MAX - BTN_MISC];

	// dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1

	union {
		struct controller_state {
			int a_button;
			int b_button;
			int x_button;
			int y_button;

			int leftshoulder_button;
			int rightshoulder_button;

			int leftstick_button;
			int rightstick_button;

			int start_button;
			int back_button;
			int guide_button;

			int lefttrigger_axis;
			int righttrigger_axis;

			int leftx_axis;
			int lefty_axis;
			int rightx_axis;
			int righty_axis;
		} state_struct;
		int state_data[17];
	} state;
};

const char *input_name_to_state_index[] = {
	"a",
	"b",
	"x",
	"y",
	"leftshoulder",
	"rightshoulder",
	"leftstick",
	"rightstick",
	"start",
	"back",
	"guide",
	"lefttrigger",
	"righttrigger",
	"leftx",
	"lefty",
	"rightx",
	"righty",
	NULL
};

void free_controller(struct controller *controller)
{
	int i;

	close(controller->fd);

	free(controller->hats);
	free(controller->name);
	free(controller->path);
	free(controller);
}

#define MAX_CONTROLLERS 16
struct controller *controllers[MAX_CONTROLLERS];
int num_controllers = 0;

/*-----------------------------------------------------------------------------
 * Purpose: Returns the 4 bit nibble for a hex character
 * Input  : c -
 * Output : unsigned char
 *-----------------------------------------------------------------------------*/
static unsigned char nibble(char c)
{
	if ((c >= '0') && (c <= '9')) {
		return (unsigned char)(c - '0');
	}

	if ((c >= 'A') && (c <= 'F')) {
		return (unsigned char)(c - 'A' + 0x0a);
	}

	if ((c >= 'a') && (c <= 'f')) {
		return (unsigned char)(c - 'a' + 0x0a);
	}

	/* received an invalid character, and no real way to return an error */
	/* AssertMsg1(false, "Q_nibble invalid hex character '%c' ", c); */
	return 0;
}

/* convert the string version of a joystick guid to the struct */
void guid_from_string(const char *str_guid, GUID_t *guid)
{
	int maxoutputbytes = GUID_SIZE;
	size_t len = str_guid - strchr(str_guid, ',');
	uint8_t *p;
	size_t i;

	/* Make sure it's even */
	len = (len) & ~0x1;

	memset(&guid->data, 0, GUID_SIZE);

	p = (uint8_t *) &guid->data;
	for (i = 0; (i < len) && ((p - (uint8_t *) &guid->data) < maxoutputbytes); i+=2, p++) {
		*p = (nibble(str_guid[i]) << 4) | nibble(str_guid[i+1]);
	}
}

int get_free_controller_slot()
{
	int i;

	for (i = 0; i < MAX_CONTROLLERS; i++) {
		if (!controllers[i])
			return i;
	}

	return -1;
}

int index_for_input_name(const char *name)
{
	int i = 0;

	while (input_name_to_state_index[i]) {
		if (strcmp(name, input_name_to_state_index[i]) == 0)
			return i;
		i++;
	}

	return -1;
}

void parse_button(struct controller *controller, char *button)
{
	char *device_button = strchr(button, ':') + 1;
	char *name = button;
	name[device_button - button - 1] = '\0';

	int button_number = atoi(&device_button[1]);

	switch (device_button[0]) {
		case 'a':
			controller->axis_mappings[button_number] = index_for_input_name(name);
			break;
		case 'b':
			controller->button_mappings[button_number] = index_for_input_name(name);
			break;
		case 'h':
		{
			int mask = atoi(&device_button[3]);
			break;
		}
	}
}

void parse_button_mapping(struct controller *controller, const char *mapping)
{
	char *mapping_copy, *token, *guid, *name;
	int i;
 
	mapping_copy = strdup(mapping);
	token = strtok(mapping_copy, ",");
	i = 0;

	while (token) {
		switch (i) {
			case 0:
				guid = token;
				break;
			case 1:
				name = token;
				break;
			default:
				parse_button(controller, token);
				break;
		}

		token = strtok(NULL, ",");
		i++;
	}

	free(mapping_copy);
}

void buffer_button_event(int controller_index, int button, int active)
{
	struct button_event *event;

	event = malloc(sizeof(struct button_event));
	event->controller_index = controller_index;
	event->button = button;
	event->active = active;
	event->next = NULL;

	if (!button_event_buffer_head)
		button_event_buffer_head = event;

	if (button_event_buffer_tail)
		button_event_buffer_tail->next = event;

	button_event_buffer_tail = event;
}

int get_controller_index(struct controller *controller)
{
	int i;

	for (i = 0; controllers[i] && controllers[i] != controller; i++)
		;

	return i;
}

void report_event(struct controller *controller, enum event_type event, int which, int arg)
{
	switch (event) {
		case HAT:
			// printf("hat event %i\n", arg);
			break;
		case BUTTON:
			// printf("%s %i\n", input_name_to_state_index[controller->button_mappings[which]], arg);
			controller->state.state_data[controller->button_mappings[which]] = arg;
			buffer_button_event(get_controller_index(controller), which, arg);
			break;
		case AXIS:
			// printf("%s %i\n", input_name_to_state_index[controller->axis_mappings[which]], arg);
			controller->state.state_data[controller->axis_mappings[which]] = arg;
			break;
	}
}

void handle_hat(struct controller *controller, uint8_t hat, int axis, int value)
{
	struct hat *the_hat;
	const uint8_t position_map[3][3] = {
		{HAT_LEFTUP, HAT_UP, HAT_RIGHTUP},
		{HAT_LEFT, HAT_CENTERED, HAT_RIGHT},
		{HAT_LEFTDOWN, HAT_DOWN, HAT_RIGHTDOWN}
	};

	the_hat = &controller->hats[hat];
	if (value < 0) {
		value = 0;
	} else if (value == 0) {
		value = 1;
	} else if (value > 0) {
		value = 2;
	}
	if (value != the_hat->axis[axis]) {
		the_hat->axis[axis] = value;
		report_event(controller, HAT, hat, position_map[the_hat->axis[1]][the_hat->axis[0]]);
	}
}


int axis_correct(struct controller* controller, int which, int value)
{
	struct axis_correct *correct;

	correct = &controller->abs_correct[which];
	if (correct->used) {
		value *= 2;
		if (value > correct->coef[0]) {
			if (value < correct->coef[1]) {
				return 0;
			}
			value -= correct->coef[1];
		} else {
			value -= correct->coef[0];
		}
		value *= correct->coef[2];
		value >>= 13;
	}

	/* Clamp and return */
	if (value < -32768)
		return -32768;
	if (value > 32767)
		return 32767;

	return value;
}


#define test_bit(nr, addr) \
	(((1UL << ((nr) % (sizeof(long) * 8))) & ((addr)[(nr) / (sizeof(long) * 8)])) != 0)
#define NBITS(x) ((((x)-1)/(sizeof(long) * 8))+1)

void handle_input_events(struct controller *controller)
{
	struct input_event events[32];
	int i, len, code;

	while ((len = read(controller->fd, events, (sizeof events))) > 0) {
		len /= sizeof(events[0]);
		for (i = 0; i < len; ++i) {
			code = events[i].code;
			switch (events[i].type) {
				case EV_KEY:
					if (code >= BTN_MISC) {
						code -= BTN_MISC;
						report_event(controller, BUTTON, controller->keymap[code], events[i].value);
					}
					break;
				case EV_ABS:
					switch (code) {
						case ABS_HAT0X:
						case ABS_HAT0Y:
						case ABS_HAT1X:
						case ABS_HAT1Y:
						case ABS_HAT2X:
						case ABS_HAT2Y:
						case ABS_HAT3X:
						case ABS_HAT3Y:
							code -= ABS_HAT0X;
							handle_hat(controller, code / 2, code % 2, events[i].value);
							break;
						default:
							events[i].value = axis_correct(controller, code, events[i].value);
							report_event(controller, AXIS, controller->abs_map[code], events[i].value);
							break;
					}
					break;
					/*case EV_REL:
					  switch (code) {
					  case REL_X:
					  case REL_Y:
					  code -= REL_X;
					  printf("Handle ball\n");
					// HandleBall(joystick, code / 2, code % 2, events[i].value);
					break;
					default:
					break;
					}
					break;*/
				case EV_SYN:
					switch (code) {
						case SYN_DROPPED :
							printf("Event SYN_DROPPED detected\n");
							// PollAllValues(joystick);
							break;
						default:
							break;
					}
				default:
					break;
			}
		}
	}
}

void config_joystick(struct controller *controller)
{
	int i, t;
	unsigned long keybit[NBITS(KEY_MAX)] = { 0 };
	unsigned long absbit[NBITS(ABS_MAX)] = { 0 };
	unsigned long relbit[NBITS(REL_MAX)] = { 0 };

	if ((ioctl(controller->fd, EVIOCGBIT(EV_KEY, sizeof(keybit)), keybit) < 0) ||
			(ioctl(controller->fd, EVIOCGBIT(EV_ABS, sizeof(absbit)), absbit) < 0) ||
			(ioctl(controller->fd, EVIOCGBIT(EV_REL, sizeof(relbit)), relbit) < 0))
		return;

	for (i = BTN_JOYSTICK; i < KEY_MAX; ++i) {
		if (test_bit(i, keybit)) {
			// printf("Joystick has button: 0x%x\n", i);
			controller->keymap[i - BTN_MISC] = controller->nbuttons;
			controller->nbuttons++;
		}
	}
	for (i = BTN_MISC; i < BTN_JOYSTICK; ++i) {
		if (test_bit(i, keybit)) {
			// printf("Joystick has button: 0x%x\n", i);
			controller->keymap[i - BTN_MISC] = controller->nbuttons;
			controller->nbuttons++;
		}
	}
	for (i = 0; i < ABS_MAX; ++i) {
		/* Skip hats */
		if (i == ABS_HAT0X) {
			i = ABS_HAT3Y;
			continue;
		}
		if (test_bit(i, absbit)) {
			struct input_absinfo absinfo;

			if (ioctl(controller->fd, EVIOCGABS(i), &absinfo) < 0) {
				continue;
			}
			/*printf("Joystick has absolute axis: 0x%.2x\n", i);
			printf("Values = { %d, %d, %d, %d, %d }\n",
					absinfo.value, absinfo.minimum, absinfo.maximum,
					absinfo.fuzz, absinfo.flat);*/
			controller->abs_map[i] = controller->naxes;
			if (absinfo.minimum == absinfo.maximum) {
				controller->abs_correct[i].used = 0;
			} else {
				controller->abs_correct[i].used = 1;
				controller->abs_correct[i].coef[0] =
					(absinfo.maximum + absinfo.minimum) - 2 * absinfo.flat;
				controller->abs_correct[i].coef[1] =
					(absinfo.maximum + absinfo.minimum) + 2 * absinfo.flat;
				t = ((absinfo.maximum - absinfo.minimum) - 4 * absinfo.flat);
				if (t != 0) {
					controller->abs_correct[i].coef[2] =
						(1 << 28) / t;
				} else {
					controller->abs_correct[i].coef[2] = 0;
				}
			}
			controller->naxes++;
		}
	}
	for (i = ABS_HAT0X; i <= ABS_HAT3Y; i += 2) {
		if (test_bit(i, absbit) || test_bit(i + 1, absbit)) {
			struct input_absinfo absinfo;

			if (ioctl(controller->fd, EVIOCGABS(i), &absinfo) < 0) {
				continue;
			}
			/* printf("Joystick has hat %d\n", (i - ABS_HAT0X) / 2);
			printf("Values = { %d, %d, %d, %d, %d }\n",
					absinfo.value, absinfo.minimum, absinfo.maximum,
					absinfo.fuzz, absinfo.flat);*/
			controller->nhats++;
		}
	}
	if (test_bit(REL_X, relbit) || test_bit(REL_Y, relbit)) {
		// ++joystick->nballs;
	}

	/* Allocate data to keep track of these thingamajigs */
	if (controller->nhats > 0) {
		controller->hats = calloc(sizeof(struct hat), controller->nhats);
		for (i = 0; i < controller->nhats; i++) {
			controller->hats[i].axis[0] = 1;
			controller->hats[i].axis[1] = 1;
		}
	}
	/*TODO if (joystick->nballs > 0) {
		if (allocate_balldata(joystick) < 0) {
			joystick->nballs = 0;
		}
	}*/
}

int determine_guid(struct controller* controller)
{
	struct input_id inpid;
	char namebuf[128];
	uint8_t *guid;

	guid = controller->guid.data;

	if (ioctl(controller->fd, EVIOCGNAME(sizeof(namebuf)), namebuf) < 0) {
		return 0;
	}

	if (ioctl(controller->fd, EVIOCGID, &inpid) < 0) {
		return 0;
	}

	*(guid++) = inpid.bustype;
	*(guid++) = 0;

	if (inpid.vendor && inpid.product && inpid.version) {
		*(guid++) = inpid.vendor;
		*(guid++) = 0;
		*(guid++) = inpid.product;
		*(guid++) = 0;
		*(guid++) = inpid.version;
		*(guid++) = 0;
	} else {
		strncpy((char*) guid, namebuf, sizeof(controller->guid) - 4);
	}

	controller->name = strdup(namebuf);

	return 1;
}

int find_mapping(struct controller *controller)
{
	GUID_t guid;
	const char *xinput_mapping;
	int i;

	for (i = 0; controller_mappings[i]; i++) {
		if (strncmp("xinput", controller_mappings[i], 6) == 0) {
			xinput_mapping = controller_mappings[i];
			continue;
		}

		guid_from_string(controller_mappings[i], &guid);

		if (memcmp(guid.data, controller->guid.data, GUID_SIZE) == 0) {
			parse_button_mapping(controller, controller_mappings[i]);
			return 1;
		}
	}

	if (strstr(controller->name, "Xbox") || strstr(controller->name, "X-Box")) {
		parse_button_mapping(controller, xinput_mapping);
		return 1;
	}

	return 0;
}

void open_joystick(const char *path)
{
	int fd, slot;
	struct controller *controller;

	if ((slot = get_free_controller_slot()) < 0) {
		printf("No free slot for new controller, max controllers: %i\n", MAX_CONTROLLERS);
		return;
	}

	fd = open(path, O_RDONLY, 0);
	fcntl(fd, F_SETFL, O_NONBLOCK);

	controller = calloc(sizeof(struct controller), 1);
	controller->fd = fd;
	controller->path = strdup(path);

	if (!determine_guid(controller)) {
		free_controller(controller);
		return;
	}

	if (!find_mapping(controller)) {
		free_controller(controller);
		return;
	}

	controllers[slot] = controller;

	config_joystick(controller);
}

void close_joystick(const char *path)
{
	int i;

	for (i = 0; i < MAX_CONTROLLERS; i++) {
		if (controllers[i] && strcmp(controllers[i]->path, path) == 0) {
			free_controller(controllers[i]);
			controllers[i] = NULL;
			return;
		}
	}
}

void device_event(enum device_event_type event, struct udev_device *dev)
{
	const char *path, *value;

	path = udev_device_get_devnode(dev);

	if (path == NULL) {
		return;
	}

	// check if we have a joystick
	value = udev_device_get_property_value(dev, "ID_INPUT_JOYSTICK");
	if (value == NULL || strcmp(value, "1") != 0) {
		value = udev_device_get_property_value(dev, "ID_CLASS");

		if (value == NULL || strcmp(value, "joystick") != 0) {
			return;
		}
	}

	if (event == DEVICE_ADDED) {
		printf("DEVICE ADDED %s\n", path);
		open_joystick(path);
	} else if (event == DEVICE_REMOVED) {
		printf("DEVICE REMOVED %s\n", path);
	}
}

int hotplug_udpate_available(struct udev_monitor *monitor)
{
	const int fd = udev_monitor_get_fd(monitor);
	fd_set fds;
	struct timeval tv;

	FD_ZERO(&fds);
	FD_SET(fd, &fds);
	tv.tv_sec = 0;
	tv.tv_usec = 0;

	return (select(fd+1, &fds, NULL, NULL, &tv) > 0) && (FD_ISSET(fd, &fds));
}

void poll(struct udev_monitor *monitor)
{
	struct udev_device *dev;
	const char *action;

	while (hotplug_udpate_available(monitor)) {
		dev = udev_monitor_receive_device(monitor);

		if (dev == NULL)
			break;

		action = udev_device_get_action(dev);
		if (strcmp(action, "add") == 0) {
			// wait for new controller to become ready
			usleep(100 * 1000);
			device_event(DEVICE_ADDED, dev);
		} else if (strcmp(action, "remove") == 0) {
			device_event(DEVICE_REMOVED, dev);
		}

		udev_device_unref(dev);
	}
}

void initial_scan(struct udev *udev)
{
	struct udev_enumerate *enumerate;
	struct udev_list_entry *devs, *item;

	enumerate = udev_enumerate_new(udev);
	udev_enumerate_add_match_subsystem(enumerate, "input");

	udev_enumerate_scan_devices(enumerate);
	devs = udev_enumerate_get_list_entry(enumerate);

	for (item = devs; item; item = udev_list_entry_get_next(item)) {
		const char *path = udev_list_entry_get_name(item);
		struct udev_device *dev = udev_device_new_from_syspath(udev, path);
		if (dev != NULL) {
			device_event(DEVICE_ADDED, dev);
			udev_device_unref(dev);
		}
	}

	udev_enumerate_unref(enumerate);
}

/* PUBLIC API */
struct udev_monitor *udev_monitor;

void controllerInit()
{
	int i;
	struct udev *udev;

	memset(controllers, 0, sizeof(struct controller *) * MAX_CONTROLLERS);

	udev = udev_new();

	udev_monitor = udev_monitor_new_from_netlink(udev, "udev");
	udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, "input", NULL);
	udev_monitor_enable_receiving(udev_monitor);

	initial_scan(udev);
}

void controllerUpdate()
{
	int i;

	for (i = 0; i < MAX_CONTROLLERS; i++) {
		if (controllers[i])
			handle_input_events(controllers[i]);
	}

	poll(udev_monitor);
}

/**
 * one based index
 *
 * @return 1 if there is a controller on the given index or 0 if there is none
 */
int controllerOn(int index)
{
	return controllers[index - 1] != NULL ? 1 : 0;
}

/**
 * one based index
 *
 * @return the state of the controller at the given index or an empty state
 *         if there is no controller for this index
 */
struct controller_state controllerState(int index)
{
	index--;

	if (!controllers[index])
		return (struct controller_state) {};

	return controllers[index]->state.state_struct;
}

uint16_t controllerNextEvent()
{
	uint16_t event_packed = 0;

	if (!button_event_buffer_head)
		return event_packed;

	// 11 bits : button_index
	// 4 bits  : controller_index
	// 1 bit   : active

	event_packed |= button_event_buffer_head->button << 5;
	event_packed |= button_event_buffer_head->controller_index << 1;
	event_packed |= button_event_buffer_head->active;

	button_event_buffer_head = button_event_buffer_head->next;
	free(button_event_buffer_head);

	return event_packed;
}
