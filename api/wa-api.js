const winston = require("winston");
require("winston-daily-rotate-file");
const { runQuery, myFormat, breakSku, runRequest } = require("./baseFunction");
const request = require("request");

const WA_API_URL = "https://api.dripsender.id/send";
const WA_TOKEN = "a8eba897-4d1e-4ed8-a96b-e22c8f405578";
const WA_ALGHI = "6287774186890";
const WA_ABDEL = "6285885351646";
const WA_RIO = "6285819062402";
const WA_ALGHI_2 = "6289654909255";

const successLogger = winston.createLogger({
  format: myFormat,
  transports: [
    new winston.transports.Console(),
    new winston.transports.DailyRotateFile({
      filename: "./log/whatsapp/success-%DATE%.log",
      datePattern: "YYMMDD",
      zippedArchive: true,
      maxSize: "5m",
      maxFiles: "14d",
    }),
  ],
});

const errorLogger = winston.createLogger({
  format: myFormat,
  transports: [
    new winston.transports.Console(),
    new winston.transports.DailyRotateFile({
      filename: "./log/whatsapp/error-%DATE%.log",
      datePattern: "YYMMDD",
      zippedArchive: true,
      maxSize: "5m",
      maxFiles: "14d",
    }),
  ],
});

const trafficLogger = winston.createLogger({
  format: myFormat,
  transports: [
    new winston.transports.Console(),
    new winston.transports.DailyRotateFile({
      filename: "./log/whatsapp/traffic-%DATE%.log",
      datePattern: "YYMMDD",
      zippedArchive: true,
      maxSize: "5m",
      maxFiles: "14d",
    }),
  ],
});

async function sendMessage(phone, text) {
  let resp = await new Promise((resolve, reject) => {
    trafficLogger.info(`Sending message to ${phone}: ${text}`);
    request.post(
      {
        url: WA_API_URL,
        json: true,
        body: {
          api_key: WA_TOKEN,
          phone,
          text,
        },
      },
      (error, response, body) => {
        if (error) {
          errorLogger.error(
            `Failed to send message to ${phone}: ${error.message}`,
          );
          return reject(error);
        }
        if (response.statusCode !== 200) {
          errorLogger.error(
            `Failed to send message to ${phone}: Received status code ${response.statusCode}`,
          );
          return reject(
            new Error(`Received status code ${response.statusCode}`),
          );
        }
        successLogger.info(`Message sent to ${phone}: ${text}`);
        resolve(body);
      },
    );
  });

  return resp;
}

async function broadcastMessage(message) {
  await sendMessage(WA_ALGHI, message);
  await sendMessage(WA_ALGHI_2, message);
  await sendMessage(WA_ABDEL, message);
  await sendMessage(WA_RIO, message);
}

module.exports = {
  WA_ALGHI,
  WA_ABDEL,
  WA_RIO,
  WA_ALGHI_2,
  sendMessage,
  broadcastMessage,
};
