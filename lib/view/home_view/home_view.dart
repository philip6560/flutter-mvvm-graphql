import 'package:flutter/material.dart';
import 'package:flutter_mvvm/view/home_view/home_view_model.dart';
import 'package:flutter_mvvm/widget/error_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final homeViewFutureProvider = FutureProvider(
    (ref) async => ref.watch(homeViewModelProvider).getWeather());

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final n = ref.watch(homeViewModelProvider);
      final weather = ref.watch(homeViewFutureProvider);
      return Scaffold(
          body: weather.when(
              data: (data) => SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.city!.name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 30),
                            ),
                            const SizedBox(width: 4),
                            Text(data.city!.country!),
                          ],
                        ),
                        Expanded(
                          child: PageView.builder(
                              itemCount: data.list!.length,
                              itemBuilder: (ctx, i) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text(
                                      //     data.list![i].main!.temp!.toString()),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(data.list![i].dtTxt!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(height: 15),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: data.list![i].weather!
                                            .map((e) => Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      n.getWeatherIcons(
                                                          e.icon!),
                                                    ),
                                                    Text(
                                                      e.main!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 20),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(e.description!),
                                                  ],
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  )),
                        )
                      ],
                    ),
                  ),
              error: (error, trace) => WeatherErrorWidget(
                  onTap: () => ref.refresh(homeViewFutureProvider)),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}
//25°