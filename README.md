# Word Count với Hadoop Streaming và R

Dự án này demo bài toán **đếm số lần xuất hiện của từ** (Word Count) sử dụng **Hadoop Streaming** với **R** làm ngôn ngữ viết Mapper và Reducer.

## Cấu trúc dự án

```
Word_Count/
├── mapper.R      # Mapper: đọc stdin, tách từ, xuất "word 1"
├── reducer.R     # Reducer: đọc stdin, cộng dồn số lần xuất hiện
├── input.txt     # Dữ liệu đầu vào
└── README.md
```

## Yêu cầu hệ thống
- **Hệ điều hành**: Linux (khuyến nghị Ubuntu hoặc Arch Linux) hoặc Window 10 trở lên
- **Java**: OpenJDK 11
- **Hadoop**: 3.3.x hoặc 3.4.x (đã cấu hình single node)
- **R**: phiên bản ≥ 4.0 (có `Rscript` trong PATH)

## Cài đặt trên môi trường Linux

```bash
# Cài Java 11 và R (Không nên cài các phiên bản mới nhất do hadoop hiện tại chỉ đang hỗ trợ jdk-11 trở về trước)

# Arch Linux
sudo pacman -S jdk11-openjdk r

# Ubuntu
sudo apt jdk11-opẹndk r

# Tải Hadoop 3.4.3
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.4.3/hadoop-3.4.3.tar.gz
tar -xzf hadoop-3.4.3.tar.gz
sudo mv hadoop-3.4.3 /usr/local/hadoop
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_HOME=~/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=~/hadoop
# Cấu hình Hadoop (core-site.xml, hdfs-site.xml, mapred-site.xml, yarn-site.xml) tham khảo tại
https://levelup.gitconnected.com/install-hadoop-on-ubuntu-operating-system-6e0ca4ef9689
```


## Cài đặt trên môi trường Windows
Tham khảo tại
https://rstudio-education.github.io/hopr/starting.html
https://duythanhcse.wordpress.com/2021/01/01/cai-dat-hadoop-tren-windows/

## Chuẩn bị dữ liệu trên HDFS

```bash
hdfs dfs -mkdir -p /user/$(whoami)/input
hdfs dfs -put input.txt /user/$(whoami)/input
```

## Chạy job Hadoop Streaming

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -D mapreduce.job.reduces=2 \
  -input /user/$(whoami)/input \
  -output /user/$(whoami)/output \
  -mapper "Rscript mapper.R" \
  -reducer "Rscript reducer.R" \
  -file mapper.R \
  -file reducer.R
```

## Xem kết quả

```bash
hdfs dfs -cat "/user/$(whoami)/output/part-*"
```
