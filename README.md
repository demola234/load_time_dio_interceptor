# load_time_dio_logger

Load Time Dio logger is a [Dio](https://pub.dev/packages/dio) interceptor that logs out the time taken to make a network request.

## How to use Load Time Dio Logger

```dart
import 'package:dio/dio.dart';
import 'package:load_time_dio_logger/load_time_dio_logger.dart';

void main() async {
  final dio = Dio();
  dio.interceptors.add(LoadTimeDioLogger());
  final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
  print(response.data);
}
```

## Output

```
Request to https://jsonplaceholder.typicode.com/posts took 0:04:067 seconds
```
