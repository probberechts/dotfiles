from beets.plugins import BeetsPlugin
from beets import library
from beets import ui

import re


class idInTitle(BeetsPlugin):
    def commands(self):
        cmd = ui.Subcommand('idintitle', help='puts the track number in the title field')

        def func(lib, opts, args):

            def is_track_already_in_title(trackField, titleField):
                trackString = "%02d. " % (trackField,)
                return titleField.strip().startswith(trackString)

            # write a new title
            def write_track_in_title_field(track, trackField, titleField):
                print "Updated ", track.__getattr__("path")
                track["title"] = "%02d. %s" % (trackField,titleField.strip(),)
                track.write()

            for track in lib.items(ui.decargs(args)):
                try:
                    trackField = track.__getattr__("track")
                    titleField = track.__getattr__("title").strip()

                    if trackField and not is_track_already_in_title(trackField, titleField):
                        write_track_in_title_field(track, trackField, titleField)
                except:
                    continue

            print "A Manual 'beet update' run is recommended. "

        cmd.func = func
        return [cmd]
