FROM node:lts
WORKDIR /app

ADD . .
RUN yarn && yarn build:prod || true && rm -rf node_modules && yarn remove --production=true @ffmpeg-installer/ffmpeg @ffprobe-installer/ffprobe

FROM node:lts-alpine
WORKDIR /app
ENV NODE_ENV=production

RUN apk add --no-cache ffmpeg

COPY --from=0 /app/dist /app/config.json /app/
COPY --from=0 /app/node_modules /app/node_modules

VOLUME [ "/app/Data" ]

ENTRYPOINT [ "node", "." ]