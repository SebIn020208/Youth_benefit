const express = require("express");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(bodyParser.json());
app.use(cors());

const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "설정한 root 비밀번호",
    database: "youth_app"
});

// 회원가입 API
app.post("/register", (req, res) => {
    const { name, email, password, age, region, disability, chronicDisease } = req.body;
    db.query(
        "INSERT INTO users (name, email, password, age, region, disability, chronicDisease) VALUES (?, ?, ?, ?, ?, ?, ?)",
        [name, email, password, age, region, disability, chronicDisease],
        (err) => {
            if (err) return res.status(500).send("회원가입 실패");
            res.send("회원가입 성공");
        }
    );
});

// 로그인 API
app.post("/login", (req, res) => {
    const { email, password } = req.body;
    db.query(
        "SELECT * FROM users WHERE email = ? AND password = ?",
        [email, password],
        (err, results) => {
            if (err) return res.status(500).send("DB 에러");
            if (results.length > 0) {
                res.send({ success: true, user: results[0] });
            } else {
                res.send({ success: false, message: "로그인 실패" });
            }
        }
    );
});

app.listen(3000, () => console.log("API 서버 실행: http://localhost:3000"));
