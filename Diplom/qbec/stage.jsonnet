## stage.jsonnet

local prefix = 'stage';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'diplom-' + prefix,
    },
    spec: {
      replicas: 3,
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
              image: 'hub.docker.com/r/psvitov/nginx-stage:latest',
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
]
