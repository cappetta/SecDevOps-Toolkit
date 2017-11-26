import os, time
from slackclient import SlackClient
from pyslack import SlackClient as slackclient

client = slackclient(os.environ.get('SLACK_BOT_TOKEN'))
BOT_NAME = 'aws_bot'
slack_client = SlackClient(os.environ.get('SLACK_BOT_TOKEN'))
# starterbot's ID as an environment variable
# BOT_ID = os.environ.get("BOT_ID")

def cmd_not_Found(command):
    '''
    if command is not in the dictionary of known commands then post msg indicating unknown cmd
    :param command:
    :return:
    '''
    if False: return "That command was not found"
    if True: return command + " Found"

def handle_command(command, channel):
    """
        Receives commands directed at the bot and determines if they
        are valid commands. If so, then acts on the commands. If not,
        returns back what it needs for clarification.
    """
    response = cmd_not_Found(command)
    slack_client.api_call("chat.postMessage", channel=channel,
                          text=response, as_user=True)
    response = "Not sure what you mean. Use the *" + EXAMPLE_COMMAND + \
               "* command with numbers, delimited by spaces."
    if command.startswith(EXAMPLE_COMMAND):
        response = "Sure...write some more code then I can do that!"
        slack_client.api_call("chat.postMessage", channel=channel,
                          text=response, as_user=True)
    elif command.startswith('help'):
        response    =   '@aws_bot <command> <arguments_or_options>' + "\n" \
                        '\h, help  provides this help screen' + "\n" \
                        'do        executes an aws commandlet' + "\n"

        slack_client.api_call("chat.postMessage", channel=channel,
                              text=response, as_user=True)

# aws functions to perform specific functions
def checkKeyAge():
    pass
def checkPassAge():
    pass
def checkLastLogin():
    pass
def createInstance():
    pass
def listInstances(keypair):
    pass
def shutdownInstances(keypair):
    pass
def createCluster(clusterName):
    '''
    receieves an expected name and orchestrates the creation / startup of a cluster
    :param clusterName:
    :return:
    '''
    pass

def checkMyAccount():
    '''

    :output: prints the status of the account scecurity
    :return: none
    '''
    checkKeyAge();
    checkPassAge();
    checkLastLogin();

def createDockerNessus(branch, ticket):
    pass

def scanTargets(targets):
    pass


def parse_slack_output(slack_rtm_output):
    """
        The Slack Real Time Messaging API is an events firehose.
        this parsing function returns None unless a message is
        directed at the Bot, based on its ID.
    """
    output_list = slack_rtm_output
    if output_list and len(output_list) > 0:
        for output in output_list:
            if output and 'text' in output and AT_BOT in output['text']:
                # return text after the @ mention, whitespace removed
                return output['text'].split(AT_BOT)[1].strip().lower(), \
                       output['channel']
    return None, None


if __name__ == "__main__":
    # constants
    BOT_ID=''

    api_call = slack_client.api_call("users.list")
    if api_call.get('ok'):
        # retrieve all users so we can find our bot
        users = api_call.get('members')
        for user in users:
            if 'name' in user and user.get('name') == BOT_NAME:
                client.chat_post_message('#General', user['name'] + " python is working", username=user['name'])
                print("Bot ID for '" + user['name'] + "' is " + user.get('id'))
                BOT_ID = user.get('id')
                AT_BOT = "<@" + BOT_ID + ">"
                EXAMPLE_COMMAND = "do"
    else:
        print("could not find bot user with the name " + BOT_NAME)



if __name__ == "__main__":
    READ_WEBSOCKET_DELAY = 1 # 1 second delay between reading from firehose
    if slack_client.rtm_connect():
        print("StarterBot connected and running!")
        while True:
            command, channel = parse_slack_output(slack_client.rtm_read())
            if command and channel:
                handle_command(command, channel)
            time.sleep(READ_WEBSOCKET_DELAY)
    else:
        print("Connection failed. Invalid Slack token or bot ID?")