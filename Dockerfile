FROM node:18.16.0-alpine as base
RUN apk add --no-cache bash
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* /tmp/app/
RUN cd /tmp/app &&         if [ -f yarn.lock ]; then yarn --frozen-lockfile;         elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile;         else npm install;         fi
COPY . /usr/src/app
RUN cp -a /tmp/app/node_modules /usr/src/app
WORKDIR /usr/src/app
RUN if [ -f tsconfig.json ]; then         npm install         typescript         && npm run build-ts         fi 
CMD ["node","dist/main.js"]