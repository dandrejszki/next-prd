
FROM node:alpine AS base

WORKDIR /base
COPY package.json .
RUN npm install
COPY . .

FROM base AS build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /base ./
RUN npm run build


FROM node:alpine AS production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /build/package*.json ./
COPY --from=build /build/.next ./.next
RUN npm install next && chown -R node: /app

EXPOSE 8080
USER node
CMD ["npm","start"]         