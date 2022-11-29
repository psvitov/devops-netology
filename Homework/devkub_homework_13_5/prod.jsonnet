local p = import '../params.libsonnet';
local params = p.components.prod;
local prefix = 'prod';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: prefix + '-deploy',
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: prefix + '-app',
          tier: prefix
        },
      },
      template: {
        metadata: {
          labels: {
            app: prefix + '-app',
            tier: prefix
          },
	},
	spec: {
          containers: [
            {
              name: prefix + '-front',
              image: params.fimage,
              imagePullPolicy: 'Always',
            },
            {
              name: prefix + '-back',
              image: params.bimage,
            },
          ],
	},
      },
    },
  },
]
