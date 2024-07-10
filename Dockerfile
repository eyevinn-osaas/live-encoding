ARG NODE_IMAGE=node:18-alpine

FROM ${NODE_IMAGE}
ENV NODE_ENV=production
EXPOSE 8000
RUN apk update
RUN apk add --no-cache ffmpeg
RUN mkdir /app
RUN chown node:node /app
RUN mkdir /data && chown node:node /data
USER node
WORKDIR /app
VOLUME [ "/data" ]
COPY --chown=node:node ["package.json", "package-lock.json*", "tsconfig*.json", "./"]
COPY --chown=node:node ["src", "./src"]
# Delete prepare script to avoid errors from husky
RUN npm pkg delete scripts.prepare \
    && npm ci --omit=dev
ENV ORIGIN_DIR=/data
ENV DEBUG=1
CMD [ "npm", "run", "start" ]
