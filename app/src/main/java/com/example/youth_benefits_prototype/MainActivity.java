package com.example.youth_benefits_prototype;


import android.os.Bundle;
import android.util.Log;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class MainActivity extends AppCompatActivity {

    private RecyclerView recyclerView;
    private WelfareAdapter adapter;
    private List<welfareItem> welfareList = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        adapter = new WelfareAdapter(welfareList);
        recyclerView.setAdapter(adapter);

        fetchWelfareData(); // API 호출
    }

    private void fetchWelfareData() {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("https://apis.data.go.kr/B554287/NationalWelfareInformationsV001/NationalWelfarelistV001?serviceKey=9gZz2YqPyja1Ij9KwIvHdug%2BuGvt34T70zxHFLlhzQ3EHJx4plGMzvkuVQ%2B9GYCNXdIdkc9TKxxLM5HWV5gcXg%3D%3D&callTp=L&pageNo=1&numOfRows=10&srchKeyCode=001&lifeArray=007&trgterIndvdlArray=050&intrsThemaArray=010&age=20&onapPsbltYn=Y&orderBy=popular")
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        JsonPlaceholderApi api = retrofit.create(JsonPlaceholderApi.class);

        Call<List<Post>> call = api.getPosts();  // posts endpoint 호출

        call.enqueue(new Callback<List<Post>>() {
            @Override
            public void onResponse(Call<List<Post>> call, Response<List<Post>> response) {
                if (!response.isSuccessful()) {
                    Log.e("API_ERROR", "Code: " + response.code());
                    return;
                }

                List<Post> posts = response.body();

                for (Post post : posts) {
                    welfareList.add(new welfareItem(post.getTitle(), post.getBody()));
                }

                adapter.notifyDataSetChanged(); // 데이터 변경 알림
            }

            @Override
            public void onFailure(Call<List<Post>> call, Throwable t) {
                Log.e("API_ERROR", "Failure: " + t.getMessage());
            }
        });
    }
}

