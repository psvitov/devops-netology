## stage.jsonnet

local prefix = 'stage';
local imageTag = std.extVar('image_tag');

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: '<имя проекта>' + prefix,
    },
    spec: {
      replicas: 1,
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
              image: 'docker.io/<login/repository>:' + imageTag,
              imagePullPolicy: 'Always',
            },
          ],
	},
      },
    },
  },
]
