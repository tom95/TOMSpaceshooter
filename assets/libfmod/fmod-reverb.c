#include <stdlib.h>
#include <locale.h>
#include <unistd.h>
#include <gtk/gtk.h>
#include <time.h>
#include "fmod.h"

FMOD_SYSTEM *fsystem;

struct prop_desc {
	const char *name;
	const char *desc;
	const char *squeakPresetPart;
	float min;
	float default_value;
	float max;
	GtkRange *value;
};

struct prop_desc props[] = {
	{"DecayTime", "Reverberation decay time in ms", "DecayTime", 0, 1500, 20000, NULL},
	{"EarlyDelay", "Initial reflection delay time", "earlyDelay", 0, 7, 300, NULL},
	{"LateDelay", "Late reverberation delay time relative to initial reflection", "lateDelay", 0, 11, 100, NULL},
	{"HFReference", "Reference high frequency (hz)", "hfReference", 20, 5000, 20000, NULL},
	{"HFDecayRatio", "High-frequency to mid-frequency decay time ratio", "hfDecayRatio", 10, 50, 100, NULL},
	{"Diffusion", "Value that controls the echo density in the late reverberation decay", "diffusion", 0, 100, 100, NULL},
	{"Density", "Value that controls the modal density in the late reverberation decay", "density", 0, 100, 100, NULL},
	{"LowShelfFrequency", "Reference low frequency (hz)", "lowShelfFrequency", 20, 250, 1000, NULL},
	{"LowShelfGain", "Relative room effect level at low frequencies", "lowShelfGain", -36, 0, 12, NULL},
	{"HighCut", "Relative room effect level at high frequencies", "highCut", 20, 20000, 20000, NULL},
	{"EarlyLateMix", "Early reflections level relative to room effect", "earlyLateMix", 0, 50, 100, NULL},
	{"WetLevel", "Room effect level (at mid frequencies)", "wetLevel", -80, -6, 20, NULL}
};
#define nProps sizeof(props)/sizeof(struct prop_desc)

union indexed_reverb_properties {
	FMOD_REVERB_PROPERTIES reverb;
	float array[nProps];
};

void print_preset_squeak()
{
	int i;

	// trick to get dots in decimal representation
	setlocale(LC_NUMERIC, "en_US.UTF-8");
	printf("reverb\n"
		"\t^FMOD\n"
		"\t\tnewFMODReverbProperties");

	for (i = 0; i < nProps; i++) {
		if (i > 0)
			printf("\t\t");

		printf("%s: %f\n", props[i].squeakPresetPart, gtk_range_get_value(props[i].value));
	}
}

void update_reverb()
{
	union indexed_reverb_properties properties;
	int i;

	for (i = 0; i < nProps; i++)
		properties.array[i] = gtk_range_get_value(props[i].value);

	FMOD_System_SetReverbProperties(fsystem, 0, &properties.reverb);

	print_preset_squeak();
}

void setup_ui(int *argc, char ***argv)
{
	GtkWidget *window;
	GtkGrid *box;
	GtkButton *commit;
	int i;

	gtk_init(argc, argv);

	window = GTK_WIDGET(gtk_window_new(GTK_WINDOW_TOPLEVEL));
	box = GTK_GRID(gtk_grid_new());

	gtk_container_set_border_width(GTK_CONTAINER(window), 12);
	gtk_grid_set_column_spacing(box, 12);
	gtk_grid_set_row_spacing(box, 6);

	for (i = 0; i < nProps; i++) {
		GtkRange *scale;
		GtkWidget *label;

		label = gtk_label_new(props[i].name);
		gtk_widget_set_halign(label, GTK_ALIGN_END);
		gtk_grid_attach(box, label, 0, i, 1, 1);

		scale = GTK_RANGE(gtk_scale_new(GTK_ORIENTATION_HORIZONTAL,
					gtk_adjustment_new(props[i].default_value, props[i].min, props[i].max, 0.001, 0.001, 0.001)));
		g_signal_connect(scale, "value-changed", G_CALLBACK(update_reverb), NULL);
		gtk_widget_set_size_request(GTK_WIDGET(scale), 200, -1);
		gtk_grid_attach(box, GTK_WIDGET(scale), 1, i, 1, 1);

		label = gtk_label_new(props[i].desc);
		gtk_widget_set_halign(label, GTK_ALIGN_START);
		gtk_grid_attach(box, label, 2, i, 1, 1);

		props[i].value = scale;
	}

	commit = GTK_BUTTON(gtk_button_new_with_label("Commit Reverb Settings"));
	g_signal_connect(commit, "clicked", G_CALLBACK(update_reverb), NULL);
	gtk_grid_attach(box, GTK_WIDGET(commit), 0, nProps, 3, 1);

	g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

	gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(box));
	gtk_widget_show_all(window);
}

int main(int argc, char **argv)
{
	setup_ui(&argc, &argv);

	FMOD_SOUND *soundtrack;
	FMOD_CHANNEL *channel1;

	FMOD_VECTOR position = { 0, 0, 0 };
	FMOD_VECTOR velocity = { 0, 0, 0 };
	FMOD_VECTOR forward = { 0, 0, 1 };
	FMOD_VECTOR up = { 0, 1, 0 };

	FMOD_System_Create(&fsystem);
	FMOD_System_Init(fsystem, 100, FMOD_INIT_NORMAL, NULL);
	FMOD_System_Set3DSettings(fsystem, 1.0f, 1.0f, 1.0f);

	FMOD_System_CreateSound(fsystem, argc < 2 ? "../sounds/blast.wav" : argv[1], FMOD_3D | FMOD_LOOP_NORMAL, 0, &soundtrack);
	FMOD_System_PlaySound(fsystem, soundtrack, NULL, 1, &channel1);
	FMOD_Channel_Set3DAttributes(channel1, &position, &velocity, NULL);
	FMOD_Channel_SetPaused(channel1, 0);

	FMOD_System_Set3DListenerAttributes(fsystem, 0, &position, &velocity, &forward, &up);
	FMOD_System_Update(fsystem);

	gtk_main();

	/*int i = 0;
	while (i < 500) {
		i++;
		FMOD_System_Update(fsystem);

		struct timespec sleepTime = { 0, 50 * 1000 * 1000 };
		nanosleep(&sleepTime, NULL);
	}*/

	FMOD_Sound_Release(soundtrack);
	FMOD_System_Close(fsystem);
	FMOD_System_Release(fsystem);
}
