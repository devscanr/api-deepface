# DeepFace (fork)

Forked from: [serengil/deepface](https://github.com/serengil/deepface).

Modified to be MacOS compatible.

Tensorflow natively supports MacOS only in latest versions. There were different `tensorflow-macos` package
previously. New Tensorflow requires newer Python, `ts-keras` instead of `keras` and so on. Dependency
list has to be modified to be able to build Docker image and run DeepFace API on MacOS ARM64.

## Test

```
$ curl http://localhost:5000/analyze -H 'Content-Type: application/json' --data '{"img_path":"https://avatars.githubusercontent.com/u/2128182?v=4","actions":["gender"],"backend":"ssd","enforce_detection": false}'
```


