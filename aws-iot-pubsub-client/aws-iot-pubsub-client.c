//this is a client utiliy to send data to unix-domain-socket-server(aws-iot-pubsub-demo-agent)
//example usage: aws-iot-pubsub-client -t test/topic_led -s {\"ledstate\":\"on\"} -v
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <string.h>
#include <cjson/cJSON.h>
//we have fixed following linux-domain-socket node in the server
static const char* socket_path = "/tmp/aws-iot-demo-agent-ipc-node";
static const unsigned int s_send_len = 4096;

void usage(const char *program)
{
    printf("Usage: %s ", program);
    printf("[-t <topic>] [-s <json-string>]\n");
    printf("    -t - topic to publish to\n");
    printf("    -s - json string to publish\n");
    printf("    -v - verbose output\n");
    printf("    e.g. %s -t test/topic_led -s {\"ledstate\":\"on\"}\n",program);
}

int main(int argc, char *argv[])
{
	int verbose = 0;
	int sock = 0;
	int data_len = 0;
	struct sockaddr_un remote;
	char send_msg[s_send_len];

	int opt = 0;
	char topic[4096];
	char data_string[4096];
	unsigned char topic_flag=0;
	unsigned char string_flag=0;
	while ((opt = getopt(argc, argv, "t:s:v")) != -1)
        {
                switch(opt)
                {
                        case 't':
				topic_flag=1;
				strcpy(topic,optarg);
                                break;
                        case 's':
                                string_flag=1;
                                strcpy(data_string,optarg);
                                break;
                        case 'v':
                                verbose=1;
                                break;
                        default:
                                usage(argv[0]);
                                return -1; 
				break;
                }
        }
	
	if( topic_flag == 0 || string_flag == 0 )
	{
		printf("-t and -s options must specified\n");
		usage(argv[0]);
		return -1;
	}
	
	//check if given topic is a valid string
	//check if given data is a valid json string
	if(strlen(topic)<=0)
	{
		printf("this is not a valid topic!!!\n");
		return -1;
	}
	if(strlen(data_string)<=2)
	{
		printf("this is not a valid json string!!!\n");
		return -1;
	}
	cJSON *extern_data = cJSON_Parse(data_string);
	if (extern_data == NULL)
	{
		printf("this is not a valid json string!!!\n");
		return -1;
	}
	cJSON *aws_data = cJSON_CreateObject();
	if (cJSON_AddStringToObject(aws_data, "topic", topic) == NULL)
	{
		cJSON_Delete(aws_data);
		printf("unable to create json object for aws_data!!\n");
		return -1;
	}
	if (cJSON_AddItemToObject(aws_data, "data", extern_data) == NULL)
	{
		cJSON_Delete(aws_data);
		cJSON_Delete(extern_data);
		printf("unable to add data object for aws_data!!\n");
		return -1;
	}
	//copy the string from json-object to send_msg
	strcpy(send_msg,cJSON_Print(aws_data));
	if(verbose)
		printf("sending: \"%s\"\n",send_msg);
	//we dont need this object anymore
	cJSON_Delete(aws_data);
	
	if( (sock = socket(AF_UNIX, SOCK_STREAM, 0)) == -1  )
	{
		printf("Client: Error on socket() call \n");
		return 1;
	}

	remote.sun_family = AF_UNIX;
	strcpy( remote.sun_path, socket_path );
	data_len = strlen(remote.sun_path) + sizeof(remote.sun_family);

	if(verbose)
		printf("Client: Trying to connect... \n");
	if( connect(sock, (struct sockaddr*)&remote, data_len) == -1 )
	{
		printf("Client: Error on connect call \n");
		return 1;
	}

	if(verbose)
		printf("Client: Connected \n");
	
	//send data to unix-domain-socket-server	
	if( send(sock, send_msg, strlen(send_msg)*sizeof(char), 0 ) == -1 )
		printf("Client: Error on send() call \n");

	if(verbose)
		printf("Client: bye! \n");
	return 0;
}

