#!/usr/bin/env node

const { Command } = require("commander");
const inquirer = require("inquirer");
const { analyzeContract } = require("./src/ai-prompt");
const fs = require("fs");
const path = require("path");
require("dotenv").config();

const program = new Command();

program
  .name("SC Audit")
  .description("A CLI tool to audit smart contracts using OpenAI")
  .version("1.59.0");

const getApiKey = async () => {
  const { apiKey } = await inquirer.prompt([
    {
      type: "input",
      name: "apiKey",
      message: "Enter your OpenAI API key:",
      validate: (input) => input.length > 0 || "API key is required",
    },
  ]);
  return apiKey;
};


program.parse(process.argv);
