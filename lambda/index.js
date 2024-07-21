const AWS = require('aws-sdk');
const sns = new AWS.SNS();

exports.handler = async (event) => {
  const params = {
    Message: 'Incident occurred: ' + JSON.stringify(event),
    TopicArn: process.env.SNS_TOPIC_ARN,
  };

  try {
    await sns.publish(params).promise();
    console.log('Message sent to the topic');
  } catch (error) {
    console.error(error);
    throw new Error('Error sending message to SNS');
  }
};