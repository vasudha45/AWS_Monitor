import express from "express";
import cors from "cors";
import AWS from "aws-sdk";
import { exec } from "child_process"; // For running Terraform commands

const app = express();
app.use(cors());
app.use(express.json());

// Route to fetch cost data based on user credentials
app.post("/fetch-costs", async (req, res) => {
  const { accessKey, secretKey, region } = req.body;

  // Dynamically update AWS credentials based on user input
  AWS.config.update({
    accessKeyId: accessKey,
    secretAccessKey: secretKey,
    region: region,
  });

  const costExplorer = new AWS.CostExplorer();

  const params = {
    TimePeriod: {
      Start: "2024-03-01", // Example start date
      End: "2024-03-03",   // Example end date
    },
    Granularity: "DAILY",
    Metrics: ["BlendedCost"],
  };

  try {
    const costData = await costExplorer.getCostAndUsage(params).promise();
    const costResults = costData.ResultsByTime.map((result) => ({
      date: result.TimePeriod.Start,
      cost: result.Total.BlendedCost.Amount,
    }));

    res.json(costResults);
  } catch (err) {
    console.error("Error fetching AWS cost data:", err);
    res.status(500).json({ message: "Error fetching cost data" });
  }
});

// Route to enable cost optimization (without actual optimization for simplicity)
app.post("/enable-optimization", async (req, res) => {
  const { accessKey, secretKey, region, userEmail } = req.body;

  // Dynamically set AWS credentials
  AWS.config.update({
    accessKeyId: accessKey,
    secretAccessKey: secretKey,
    region: region,
  });

  // Simulating optimization logic (without real ML or Terraform)
  const costThreshold = 100; // Optimization threshold
  const currentCost = 120;   // Simulated cost value

  let optimizationMessage = "No optimization needed.";

  // If the current cost exceeds the threshold, we "trigger" optimization
  if (currentCost > costThreshold) {
    optimizationMessage = "Optimization triggered! Unused EC2 instances will be stopped.";
    
    // Simulate running Terraform (no real Terraform commands here)
    exec('echo "Running Terraform apply..."', (err, stdout, stderr) => {
      if (err) {
        console.error("Error running Terraform:", err);
        return res.status(500).json({ message: "Terraform apply failed" });
      }
      console.log("Terraform output:", stdout);
    });
  }

  // **Console log the "notification" instead of sending emails**
  console.log(`AWS Cost Optimization: ${optimizationMessage}`);

  // Respond to the user with the message
  res.json({ message: `Optimization completed. ${optimizationMessage}` });
});

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Backend server running on http://localhost:${PORT}`);
});
