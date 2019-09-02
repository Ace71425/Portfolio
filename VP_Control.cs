using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Video;
using UnityEngine.Video;

public class VP_Control : MonoBehaviour {
	
	private VideoPlayer videoPlayer;
	private AudioSource audioPlayer;
	public static VP_Control access;
	private int syncswitch;
	public int onfinish;

	// Use this for initialization
	void Start ()
	{
		access = this;
		syncswitch = 0;
		audioPlayer = GetComponent<AudioSource>();
		videoPlayer = GetComponent<VideoPlayer>();
		onfinish = 0;
	}

	public void alterplayer()
	{
		videoPlayer.clip = ButtonClicks.access.Currentvideo;
		videoPlayer.Play();
		audioPlayer.clip = ButtonClicks.access.Currentaudio;
	}
	
	public void audiotime()
	{
		audioPlayer.clip = ButtonClicks.access.Launchaudio;
		audioPlayer.Play();
	}

	void Update()
	{
		if (videoPlayer.isPlaying == true && syncswitch == 0)
		{
			audioPlayer.Play();
			
			syncswitch = 1;
		}

		if (!audioPlayer.isPlaying)
		{
			videoPlayer.Stop();
			videoPlayer.clip = null;
			videoPlayer.audioOutputMode = VideoAudioOutputMode.None;
			ABut.access.Nextbut();
			
			///syncswitch = 0;

			if (syncswitch == 1)
			{
				syncswitch = 0;
				ButtonClicks.access.Freezeplay = 0;
			}

		}
		
	}
	
}
