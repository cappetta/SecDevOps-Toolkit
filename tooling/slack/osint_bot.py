import os
import time
import urllib
import calendar
import feedparser
from datetime import datetime
from slackclient import SlackClient

def post_to_slack(slack_client, post, slack_channels):
    for slack_channel in slack_channels.split():
        try:
            slack_client.api_call('chat.postMessage', channel=slack_channel, text=post, link_names=1, as_user='true')
        except Exception:
            pass

if __name__ == '__main__':
    if os.environ.get('SLACK_BOT_TOKEN') == None:
        print("TOKEN environment variable has not been set")
        exit(0)

    # calculate the start time. We'll only send on posts that are new
    lastcheck = calendar.timegm(time.gmtime())
    lastcheck += 18000; # add 5 hours

    # setup slack connection
    token = os.environ['SLACK_BOT_TOKEN']
    slack_client = SlackClient(token)

    while True:
        try:
            feed = feedparser.parse('https://www.reddit.com/r/netsec/new/.rss')
            for entry in feed.entries:
                if (entry.title.find("Security Hiring Thread") == -1 and entry.author != "/u/AutoModerator"):
                    print("entry_title: " + entry.title)
                    time_posted = int(time.mktime(time.strptime(entry.updated, '%Y-%m-%dT%H:%M:%S+00:00')))
                    # if (time_posted > lastcheck):
                    post = "*New on /r/netsec:* <" + entry.link + "|" + entry.title + "> by " + entry.author
                    post_to_slack(slack_client, post, 'general')
        except Exception:
            pass

        lastcheck = calendar.timegm(time.gmtime())
        lastcheck += 18000; # add 5 hours
        time.sleep(60*20)

