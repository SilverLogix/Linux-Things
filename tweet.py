#!/usr/bin/env python3

# Requires sudo apt-get install python3-tk

from time import sleep

from PySimpleGUI import Window, Input, FileBrowse, Button, theme, Text
import tweepy

# SETUP KEYS ///////////////////////////////
_keys = dict(
    username="@USERNAME",
    consumer_key='KEY',
    consumer_secret='KEY',
    access_token='KEY',
    access_token_secret='KEY'
)

# CREATE AUTHORIZATION /////////////////////
_auth = tweepy.OAuthHandler(_keys['consumer_key'], _keys['consumer_secret'])
_auth.set_access_token(_keys['access_token'], _keys['access_token_secret'])

_API = tweepy.API(_auth)


# /////////////////////////////////////////  MAIN CODE  ///////////////////////////////////////

theme('BluePurple')  # Set color theme

_layout = [[Text('Type your Tweet      '), Text(size=(22, 1), key='-OUT-')],
           [Input(key='-TXT-')],
           [Text('')],
           [Text('Choose image (Optional)')],
           [Input(key='-IMG-'), FileBrowse()],
           [Button('TXT Post'), Button('IMG Post'), Button('  EXIT  ')]]

_window = Window('Tweet GUI', _layout, icon="assets/twitter.png")  # Set title & icon
# _window = Window('Tweet GUI', _layout, no_titlebar=True, alpha_channel=1, grab_anywhere=True)


# DEFINE POSTING ////////////////////
def tweet():
    _API.update_status((values['-TXT-']))
    sleep(1)


def tweet_photo():
    status = values['-TXT-']
    x = values['-IMG-']
    _API.update_with_media(filename=x, status=status)
    sleep(2)


while True:  # Event Loop
    event, values = _window.read()
    print(event, values)
    if event in (None, '  EXIT  '):
        break

    if event == 'TXT Post':
        _window['-OUT-'].update('Tweet Sent!')
        tweet()

    if event == 'IMG Post':
        _window['-OUT-'].update('Tweet w/ IMG Sent!')
        tweet_photo()

_window.close()
