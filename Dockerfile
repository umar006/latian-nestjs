# syntax=docker/dockerfile:1

FROM node:18.16.0-alpine as development

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

#######################################
FROM node:18.16.0-alpine as build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

COPY --from=development /usr/src/app/node_modules ./node_modules

COPY . .

RUN yarn build

ENV NODE_ENV production

RUN yarn install --frozen-lockfile --production && yarn cache clean --force

USER node

#######################################
FROM node:18.16.0-alpine as production

COPY --from=build /usr/src/app/node_modules ./node_modules

COPY --from=build /usr/src/app/dist ./dist

CMD [ "node", "dist/main.js" ]
