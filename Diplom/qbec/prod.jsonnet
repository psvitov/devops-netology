## prod.jsonnet

local p = import '../params.libsonnet';
local params = p.components.prod;
local prefix = 'prod';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'diplom-' + prefix,
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: 'app-' + prefix,
          tier: prefix
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'app-' + prefix,
            tier: prefix
          },
        },
        spec: {
          containers: [
            {
              name: 'front-' + prefix,
              image: params.image,
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
]
