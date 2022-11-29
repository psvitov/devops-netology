local prefix = 'stage';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: prefix + '-deploy',
    },
    spec: {
      replicas: 1,
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
              image: 'nginx:stable',
              imagePullPolicy: 'Always',
            },
            {
              name: prefix + '-back',
              image: 'busybox',
            },
          ],
	},
      },
    },
  },
]
