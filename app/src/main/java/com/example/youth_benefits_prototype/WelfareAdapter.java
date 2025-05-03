package com.example.youth_benefits_prototype;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class WelfareAdapter extends RecyclerView.Adapter<WelfareAdapter.WelfareViewHolder> {

    private List<welfareItem> itemList;
    private Context context;

    public WelfareAdapter(List<welfareItem> itemList, Context context) {
        this.itemList = itemList;
        this.context = context;
    }

    public static class WelfareViewHolder extends RecyclerView.ViewHolder {
        TextView titleText, descriptionText, targetText;
        Button applyButton;

        public WelfareViewHolder(@NonNull View itemView) {
            super(itemView);
            titleText = itemView.findViewById(R.id.titleText);
            descriptionText = itemView.findViewById(R.id.descriptionText);
            targetText = itemView.findViewById(R.id.targetText);
            applyButton = itemView.findViewById(R.id.applyButton);
        }
    }

    @NonNull
    @Override
    public WelfareViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_card, parent, false);
        return new WelfareViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull WelfareViewHolder holder, int position) {
        welfareItem item = itemList.get(position);
        holder.titleText.setText(item.getTitle());
        holder.descriptionText.setText(item.getDescription());
        holder.targetText.setText("대상: " + item.getTarget());

        holder.applyButton.setOnClickListener(v -> {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(item.getLink()));
            context.startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return itemList.size();
    }
}

