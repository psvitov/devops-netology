// this file has the baseline default parameters
{
  components: { // required
    prod: {
      replicas: 3,
      fimage: 'nginx:stable',
      bimage: 'busybox'
    },
  },
}
