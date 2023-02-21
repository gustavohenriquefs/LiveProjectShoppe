curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o ./jq
chmod a+x ./jq

# GET VERSION
VERSION=$(node --eval="process.stdout.write(require('./package.json').version)")
yarn install
yarn build

# Pega um arquivo(import-map) da nuvem(s3) e dá um alias, no caso: import-map
aws s3 cp s3://mfe-shoppe-aula/config/import-map.json import-map.json

# Atualização da versão da URL
NEW_URL=/config/mfe/app-header/$VERSION/shoppe-app-header.js

# Agora modificando o import-map.json
# cat loga o arquino no nosso console
cat ./import-map.json | ./jq --arg NEW_URL "$NEW_URL" '.imports["@shoppe/app-header"] = $NEW_URL' > new.importmap.json


#UPLOAD build
aws s3 cp dist s3://mfe-shoppe-aula/config/mfe/app-header/$VERSION --recursive

# UPLOAD new import-map
aws s3 cp new.importmap.json s3://mfe-shoppe-aula/config/import-map.json

# CACHE INVALIDATION
aws cloudfront create-invalidation --distribution-id E2CSYO6LJ44WFR --paths '/config/import-map.json'